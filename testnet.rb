#!/usr/bin/env ruby

require 'fileutils'
require 'yaml'
require 'open3'
require_relative './client.rb'

module BitShares

  class TestNet

    attr_reader :delegate_node, :alice_node, :bob_node

    TEMPDIR = 'tmp'

    def initialize(logger = nil)
      @logger = logger
      @delegate_node = nil
      @alice_node = nil
      @bob_node = nil
    end

    def log(s)
      if @logger then @logger.info s else puts s end
    end

    def recreate_dir(dir); FileUtils.rm_rf(dir); Dir.mkdir(dir) end

    def td(path); "#{TEMPDIR}/#{path}"; end

    def create_client_node(dir, port, create=true)
      clientnode = BitSharesNode.new @client_binary, name: dir, data_dir: td(dir), genesis: "test_genesis.json", http_port: port, logger: @logger
      clientnode.start(false)
      if create
        clientnode.exec 'wallet_create', 'default', '123456789'
        clientnode.exec 'wallet_unlock', '9999999', '123456789'
      end
      return clientnode
    end

    def full_bootstrap
      log '========== full bootstrap ==========='
      FileUtils.rm_rf td('delegate_wallet_backup.json')
      FileUtils.rm_rf td('alice_wallet_backup.json')
      FileUtils.rm_rf td('bob_wallet_backup.json')
      @delegate_node.exec 'wallet_create', 'default', '123456789'
      @delegate_node.exec 'wallet_unlock', '9999999', '123456789'

      File.open('test_genesis.json.keypairs') do |f|
        counter = 0
        f.each_line do |l|
          pub_key, priv_key = l.split(' ')
          @delegate_node.exec 'wallet_import_private_key', priv_key, "delegate#{counter}"
          counter += 1
          #break if counter > 10
        end
      end

      sleep 1.0

      for i in 0..10
        @delegate_node.exec 'wallet_delegate_set_block_production', "delegate#{i}", true
      end

      balancekeys = []
      File.open('test_genesis.json.balancekeys') do |f|
        f.each_line do |l|
          balancekeys << l.split(' ')[1]
        end
      end

      @delegate_node.exec 'wallet_import_private_key', balancekeys[0], "account0", true, true
      @delegate_node.exec 'wallet_import_private_key', balancekeys[1], "account1", true, true

      for i in 0..100
        @delegate_node.exec 'wallet_delegate_set_block_production', "delegate#{i}", true
      end

      @delegate_node.wait_new_block

      for i in 0..100
        @delegate_node.exec 'wallet_transfer', 1000000, 'XTS', "account#{i%2}",  "delegate#{i}"
      end

      @delegate_node.wait_new_block
      #STDIN.getc

      res = @delegate_node.exec 'wallet_account_transaction_history'
      res.each do |trx|
        next if trx['block_num'].to_i == 0
        @delegate_node.exec 'wallet_scan_transaction', trx['trx_id']
      end

      for i in 0..100
        @delegate_node.exec 'wallet_publish_price_feed', "delegate#{i}", 0.01, 'USD'
      end

      @delegate_node.exec 'wallet_backup_create', td('delegate_wallet_backup.json')

      #@alice_node = create_client_node('alice', 5691)
      @alice_node.exec 'wallet_import_private_key', balancekeys[2], "genesis", true, true
      @alice_node.exec 'wallet_backup_create', td('alice_wallet_backup.json')

      #@bob_node = create_client_node('bob', 5692)
      @bob_node.exec 'wallet_import_private_key', balancekeys[3], "genesis", true, true
      @bob_node.exec 'wallet_backup_create', td('bob_wallet_backup.json')
    end

    def quick_bootstrap
      log '========== quick bootstrap ==========='
      @delegate_node.exec 'wallet_backup_restore', td('delegate_wallet_backup.json'), 'default', '123456789'
      @alice_node.exec 'wallet_backup_restore', td('alice_wallet_backup.json'), 'default', '123456789'
      @bob_node.exec 'wallet_backup_restore', td('bob_wallet_backup.json'), 'default', '123456789'
    end

    def create
      Dir.mkdir TEMPDIR unless Dir.exist? TEMPDIR
      recreate_dir td('delegate')
      recreate_dir td('alice')
      recreate_dir td('bob')

      @client_binary = ENV['BTS_BUILD'] + '/programs/client/bitshares_client'

      @delegate_node = BitSharesNode.new @client_binary, name: 'delegate', data_dir: td('delegate'), genesis: "test_genesis.json", http_port: 5690, delegate: true, logger: @logger
      @delegate_node.start(false)

      @alice_node = create_client_node('alice', 5691, false)
      @bob_node = create_client_node('bob', 5692, false)

      nodes = [@delegate_node, @alice_node, @bob_node]

      while nodes.length > 0
        nodes.each_with_index do |n, i|
          #log "waiting for node #{n.name}"
          line = n.stdout_gets
          #log "#{n.name}: #{line}"
          if line.include? "Starting HTTP JSON RPC server on port"
            puts "node #{n.name} is up"
            nodes.delete_at(i)
          end
        end
      end

      if File.exist? td ('delegate_wallet_backup.json') and ARGV[0] != 'full'
        quick_bootstrap
      else
        full_bootstrap
      end
    end

    def shutdown
      log "shutdown"
      @delegate_node.exec 'quit'
      @alice_node.exec 'quit' if @alice_node
      @bob_node.exec 'quit' if @bob_node
    end


  end

end

if $0 == __FILE__
  testnet = BitShares::TestNet.new
  testnet.create
  STDIN.getc
  testnet.shutdown
  puts "finished"
end
require 'rspec/expectations'
require 'logger'
require './testnet.rb'

logger = Logger.new('features.log')
logger.info '--------------------------------------'

Actor = Struct.new(:node, :account) do
end

Before do
  #puts "---- before all"
end

Before do |scenario|
  puts 'launching testnet, please wait..'
  @testnet = BitShares::TestNet.new(logger)
  @testnet.create
  @testnet.alice_node.exec 'wallet_account_create', 'alice'
  @testnet.alice_node.exec 'wallet_account_register', 'alice', 'angel'
  @testnet.bob_node.exec 'wallet_account_create', 'bob'
  @testnet.bob_node.exec 'wallet_account_register', 'bob', 'angel'
  @testnet.alice_node.wait_new_block

  @logger = logger
  @alice = Actor.new(@testnet.alice_node, 'alice')
  @bob = Actor.new(@testnet.bob_node, 'bob')
end

After do |scenario|
  puts 'shutting down testnet..'
  @testnet.shutdown
end

at_exit do
  if @testnet.running
    @testnet.shutdown
    puts 'press any key to exit..'
    STDIN.getc
  end
end

class ApiHelper

  def get_actor(name)
    if name == 'my' or name == 'I'
      @current_actor
    elsif name == 'Alice' or name == "Alice's"
      @alice
    elsif name == 'Bob' or name == "Bob's"
      @bob
    else
      raise "Unknown actor '#{name}'"
    end
  end

  def get_asset_by_name(currency)
    return @testnet.delegate_node.exec 'blockchain_get_asset', currency
  end

  def get_balance(data, account, currency)
    asset = get_asset_by_name(currency)
    asset_id = asset['id']
    data.each do |account_pair|
      if account_pair[0] == account
        account_pair[1].each do |balance_pair|
          next if balance_pair[0] != asset_id
          return balance_pair[1].to_f / asset['precision'].to_f
        end
      end
    end
    return 0
  end

  def find_order(orders, o)
    #puts 'find order'
    #puts "order: #{o.inspect}"
    #puts "orders: #{orders.inspect}"
    orders.each do |e|
      order = e[1]
      if order['type'] == o['Type'] and
         order['collateral'].to_f/100000.0 == o['Collateral'].to_f and
         order['interest_rate']['ratio'].to_f * 100.0 == o['Interest Rate'].to_f
        return true
      end
    end
    return false
  end

  def wait
    puts 'waiting next block'
    @testnet.delegate_node.wait_new_block
  end

end

World( RSpec::Matchers )
World{ ApiHelper.new }

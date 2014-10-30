require 'rspec/expectations'
require 'logger'
require './testnet.rb'

puts 'bootstrapping testnet, please wait..'

logger = Logger.new('features.log')
logger.info '--------------------------------------'

testnet = BitShares::TestNet.new(logger)
testnet.create
testnet.alice_node.exec 'wallet_account_create', 'alice'
testnet.alice_node.exec 'wallet_account_register', 'alice', 'genesis'
testnet.bob_node.exec 'wallet_account_create', 'bob'
testnet.bob_node.exec 'wallet_account_register', 'bob', 'genesis'
testnet.alice_node.wait_new_block

Actor = Struct.new(:node, :account) do
end

alice = Actor.new(testnet.alice_node, 'alice')
bob = Actor.new(testnet.bob_node, 'bob')

Before do |scenario|
  @logger = logger
  @testnet = testnet
  @alice = alice
  @bob = bob
end

at_exit do
  puts "press any key to exit.."
  STDIN.getc
  testnet.shutdown
end

class ApiHelper

  def get_actor(name)
    if name == 'my'
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
    return nil
  end

end

World( RSpec::Matchers )
World{ ApiHelper.new }

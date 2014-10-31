Given(/^feed price is (.+) ([A-Z]+)\/XTS$/) do |price, symbol|
  @feed_price = price.to_f
  node = @testnet.delegate_node
  @testnet.for_each_delegate do |delegate_name|
    node.exec 'wallet_publish_price_feed', delegate_name, price, symbol
  end
end

When(/^I short (\d+) ([A-Z]+), interest rate (\d+)%$/) do |amount, symbol, ir|
  #@current_actor.node.exec 'rescan'
  collateral = 2 * amount.to_f/@feed_price
  @current_actor.node.exec 'wallet_market_submit_short', @current_actor.account, collateral, 'XTS', ir, symbol, 0
end

When(/^(\w+) submits (bid|ask) for (\d+) ([A-Z]+) at ([\d\.]+) ([A-Z]+)\/([A-Z]+)$/) do |name, order_type, amount, symbol, price, ps1, ps2|
  actor = get_actor(name)
  #actor.node.exec 'rescan'
  data = actor.node.exec 'wallet_account_balance', actor.account
  balance = get_balance(data, actor.account, symbol)
  puts "#{name}'s' balance: #{balance} #{symbol}"
  if order_type == 'bid'
    actor.node.exec 'wallet_market_submit_bid', actor.account, amount, symbol, price, ps2
  elsif order_type == 'ask'
    actor.node.exec 'wallet_market_submit_ask', actor.account, amount, symbol, price, ps1
  else
    raise "Uknown order type: #{order_type}"
  end
end

Then(/^Bob's balance should increase by (\d+) USD$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see the following ([A-Z]+)\/([A-Z]+) market orders?:$/) do |symbol1, symbol2, orders_table|
    orders_table.hashes.each do |o|
      orders = @current_actor.node.exec 'wallet_market_order_list', symbol1, symbol2, 0
      found = find_order(orders, o)
      raise "Order not found: #{o} in #{orders}" unless found
    end
end

#   >> wallet_market_order_list USD XTS 0 alice
#
# [[
#     "342f81efc92e0e1fed0397571f7846021ae08b34",{
#       "type": "cover_order",
#       "market_index": {
#         "order_price": {
#           "ratio": "0.0005",
#           "quote_asset_id": 7,
#           "base_asset_id": 0
#         },
#         "owner": "XTSBuC6mbkG3X6AZg1Wab1QmXa7xMCRamT6F"
#       },
#       "state": {
#         "balance": 1000000,
#         "short_price_limit": null,
#         "last_update": "19700101T000000"
#       },
#       "collateral": 3000000000,
#       "interest_rate": {
#         "ratio": "0.1",
#         "quote_asset_id": 7,
#         "base_asset_id": 0
#       },
#       "expiration": "20141031T205340"
#     }
#   ]
# ]
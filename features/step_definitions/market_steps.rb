Given(/^feed price is (.+) ([A-Z]+)\/XTS$/) do |price, symbol|
  @feed_price = price.to_f
  node = @testnet.delegate_node
  @testnet.for_each_delegate do |delegate_name|
    node.exec 'wallet_publish_price_feed', delegate_name, price, symbol
  end
end

When(/^I short (\d+) ([A-Z]+), interest rate (\d+)%$/) do |amount, symbol, ir|
  @current_actor.node.wait_new_block
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

Then(/^I should see margin order$/) do
  pending # express the regexp above with the code you wish you had
#   >> wallet_market_order_list USD XTS 0 alice
#
# [[
#     "5d7aa1eebcdce55ab21c2e76beed8c1c7ef40afa",{
#       "type": "short_order",
#       "market_index": {
#         "order_price": {
#           "ratio": "0.1",
#           "quote_asset_id": 7,
#           "base_asset_id": 0
#         },
#         "owner": "XTSG11EWwFabSzaBc3Gn2xG9vjzYUP4sN1iZ"
#       },
#       "state": {
#         "balance": 2000000000,
#         "short_price_limit": null,
#         "last_update": "20141030T212316"
#       },
#       "collateral": 2000000000,
#       "interest_rate": {
#         "ratio": "0.1",
#         "quote_asset_id": 7,
#         "base_asset_id": 0
#       },
#       "expiration": null
#     }
#   ]
# ]
end

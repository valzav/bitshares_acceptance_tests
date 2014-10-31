Given(/^I'm (\w+)$/) do |name|
  @current_actor = get_actor(name)
end

Given(/^(\w+) received (\d+) ([A-Z]+) from angel/) do |name, amount, currency|
  actor = get_actor(name)
  actor.node.exec 'wallet_transfer', amount, currency, 'angel', actor.account
end

When(/^I send (\d+) ([A-Z]+) to (\w+)$/) do |amount, currency, account|
  @current_actor.node.exec 'wallet_transfer', amount, currency, @current_actor.account, account.downcase
end

When(/^wait for next block$/) do
  @current_actor.node.wait_new_block
end

When(/^print ([A-Z]+) balance$/) do |symbol|
  data = @current_actor.node.exec 'wallet_account_balance', @current_actor.account
  balance = get_balance(data, @current_actor.account, symbol)
  puts "Balance: #{balance} #{symbol}"
end

Then(/^([\w']+) balance should be (\d+) ([A-Z]+)\s?(.*)$/) do |name, amount, currency, minus_fee|
  actor = get_actor(name)
  data = actor.node.exec 'wallet_account_balance', actor.account
  balance = get_balance(data, actor.account, currency)
  amount = amount.to_f - 0.5 if minus_fee == 'minus fee'
  expect(balance).to eq(amount.to_f)
end

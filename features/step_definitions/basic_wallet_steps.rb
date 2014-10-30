Given(/^I'm (\w+)$/) do |name|
  @current_actor = get_actor(name)
end

Given(/^I received (\d+) ([A-Z]+) from genesis$/) do |amount, currency|
  @current_actor.node.exec 'wallet_transfer', amount, currency, 'genesis', @current_actor.account
  @current_actor.node.wait_new_block
end

When(/^I send (\d+) ([A-Z]+) to (\w+)$/) do |amount, currency, account|
  @current_actor.node.exec 'wallet_transfer', amount, currency, @current_actor.account, account.downcase
end

When(/^wait for the next block$/) do
  @current_actor.node.wait_new_block
end

Then(/^([\w']+) balance should be (\d+) ([A-Z]+)\s?(.*)$/) do |name, amount, currency, minus_fee|
  actor = get_actor(name)
  data = actor.node.exec 'wallet_account_balance', actor.account
  balance = get_balance(data, actor.account, currency)
  amount = amount.to_f - 0.5 if minus_fee == 'minus fee'
  expect(balance).to eq(amount.to_f)
end

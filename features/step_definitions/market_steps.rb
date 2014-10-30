Given(/^feed price is (.+) ([A-Z]+)\/XTS$/) do |price, currency|
  puts "---- price, currency = #{price} #{currency}"
  node = @testnet.delegate_node
  @testnet.for_each_delegate do |delegate_name|
    node.exec 'wallet_publish_price_feed', delegate_name, price, currency
  end
end

When(/^I short (\d+) USD$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^Bob places an order for (\d+) USD$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^Bob's balance should increase by (\d+) USD$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^Alice should see margin order$/) do
  pending # express the regexp above with the code you wish you had
end

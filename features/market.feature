Feature: Short BitUSD
  As a XTS bull
  I want to short BitUSD
  So I can profit from XTS price rise

Scenario: Alice shorts 100 USD and sells to Bob
  Given I'm Alice
  And feed price is 0.01 USD/XTS
  And I received 100000 XTS from genesis
  When I short 100 USD
  And Bob places an order for 100 USD
  And wait for the next block
  Then Bob's balance should be 100 USD
  And my balance should be 80000 XTS minus fee
  And I should see margin order

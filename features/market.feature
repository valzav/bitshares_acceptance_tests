Feature: Short BitUSD
  As a XTS bull
  I want to short BitUSD
  So I can profit from XTS price rise

Scenario: Alice shorts 100 USD and sells to Bob
  Given I'm Alice
  And feed price is 0.01 USD/XTS
  And I received 100000 XTS from genesis
  And Bob received 100000 XTS from genesis
  And wait for next block
  And wait for next block
  And wait for next block
  And wait for next block
  And print XTS balance
  When I short 100 USD, interest rate 10%
  And Bob submits ask for 10000 XTS at 0.01 USD/XTS
  And wait for next block
  And wait for next block
  And wait for next block
  And wait for next block
  Then Bob's balance should be 100 USD
  And my balance should be 80000 XTS minus fee
  And I should see margin order

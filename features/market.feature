Feature: Short/cover BitUSD
  As a XTS bull
  I want to short BitUSD
  So I can profit from XTS price rise
  And I cover it later

@pause
Scenario: Alice shorts BitUSD and sells to Bob, then Bob shorts and Alice covers
  Given I'm Alice
  And feed price is 0.01 USD/XTS
  And I wait for one block
  And I received 100,000 XTS from angel
  And Bob received 100,000 XTS from angel
  And I wait for 2 blocks
  And I print XTS balance
  When I short 100 USD paying 10% interest rate
  And Bob submits ask to sell 10,000 XTS at 0.01 USD/XTS
  And I wait for 2 blocks
  Then Bob should have 100 USD
  And I should have 80,000 XTS minus fee
  And I should have the following USD/XTS market order:
    | Type        | Collateral | Interest Rate |
    | cover_order | 30000      | 10            |
  When Bob shorts 200 USD paying 11% interest rate
  And I submit ask to sell 12000 XTS at 0.01 USD/XTS
  And I wait for 2 blocks
  Then I should have 68,000 XTS minus 2*fee
  And I should have 120 USD
  And Bob should have 50,000 XTS minus 2*fee
  When I cover last USD margin order in full
  And I wait for 2 blocks
  Then I should have around 20 USD
  And I should have no USD/XTS margin orders

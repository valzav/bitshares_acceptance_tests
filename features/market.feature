Feature: Short BitUSD
  As a XTS bull
  I want to short BitUSD
  So I can profit from XTS price rise

Scenario: Alice shorts BitUSD and sells to Bob, then Bob shorts and Alice covers
  Given I'm Alice
  And feed price is 0.01 USD/XTS
  And wait for next block
  And I received 100000 XTS from angel
  And Bob received 100000 XTS from angel
  And wait for next block
  And print XTS balance
  When I short 100 USD, interest rate 10%
  And Bob submits ask for 10000 XTS at 0.01 USD/XTS
  And wait for next block
  And wait for next block
  Then Bob's balance should be 100 USD
  And my balance should be 80000 XTS minus fee
  And I should see the following USD/XTS market order:
    | Type        | Collateral | Interest Rate |
    | cover_order | 30000      | 10            |

  # TODO: complete scenario - Bob shorts and Alice covers

Feature: Transfer funds from one account to another
  As a regular user
  I want to send funds to my friend
  So that I can make him happy

Scenario: Alice sends 100 XTS to Bob
  Given I'm Alice
  And I received 1000 XTS from angel
  And wait for next block
  And print XTS balance
  When I send 100 XTS to Bob
  And wait for next block
  Then my balance should be 900 XTS minus fee
  And Bob's balance should be 100 XTS

Scenario: Bob sends 50 XTS to Alice
  Given I'm Bob
  And I received 500 XTS from angel
  And wait for next block
  When I send 50 XTS to Alice
  And wait for next block
  Then Alice's balance should be 50 XTS
  And Bob's balance should be 450 XTS minus fee

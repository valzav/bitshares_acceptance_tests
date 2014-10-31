Feature: Transfer funds from one account to another
  As a regular user
  I want to send funds to my friend
  So that I can make him happy

Scenario: Alice sends 100 XTS to Bob
  Given I'm Alice
  And I received 1000 XTS from genesis
  When I send 100 XTS to Bob
  And wait for the next block
  Then my balance should be 900 XTS minus fee
  And Bob's balance should be 100 XTS

Scenario: Bob sends 50 XTS to Alice
  Given I'm Bob
  When I send 50 XTS to Alice
  And wait for the next block
  Then Alice's balance should be 950 XTS minus fee
  And Bob's balance should be 50 XTS minus fee

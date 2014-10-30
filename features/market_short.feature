#Feature: Short BitUSD into existence
#  In order to create BitUSD
#  Users should be able short it into existence
#
#Scenario: Alice shorts 100 USD and sells to Bob
#  Given I'm Alice
#  When I short 100 USD
#  And Bob places an order for 100 USD
#  Then Bob's balance should increase by 100 USD
#  And Alice should see margin order

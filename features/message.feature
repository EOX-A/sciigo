Feature: Message model
  
  Scenario: Test basic setup
    Given I have an array of Environment Variables
    When I create a new instance of the message class 
    Then basic attributes should be set

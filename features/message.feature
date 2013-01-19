Feature: Message
  Scenario: Basic message creation
    Given I have a full set of environment variables
    And I instantiate a new Sciigo::Nagios object
    When I create a new Sciigo::Message object
    Then it should have the recipient set
    And it should have a message set
    And it should have a priority
    And it should have a url

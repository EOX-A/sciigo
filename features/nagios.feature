Feature: Nagios abstraction
  
  Scenario: Parse nagios environment variables
    Given I have an array of Environment Variables
    When I instantiate a new Nagios class
    Then the class should provides wrappers for nagios variables

  Scenario: Recognize notification type
    Given I have an array of Environment Variables
    And I instantiate a new Nagios class
    When I ask it for the notification type
    Then the class should respond with the corresponding type

  Scenario: Differentiate host & service notifications
    Given I have an array of Environment Variables
    And I instantiate a new Nagios class
    When I ask for the notification category
    Then the class should respond with either service or host

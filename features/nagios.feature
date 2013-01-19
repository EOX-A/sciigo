Feature: Nagios
  Scenario: Parse Environment Variables
    Given I have a basic set of environment variables
    When I instantiate a new Sciigo::Nagios object
    Then I should get a Hash(like) object
    And it should contain the Nagios variables
    And it should not contain non Nagios variables

  Scenario: Exception when no Nagios environment variables are available
    Given I have a non Nagios environment
    When I instantiate a new Sciigo::Nagios object
    Then I should get an Sciigo::Error

  Scenario: Transport parsing
    Given I have a basic set of environment variables
    When I instantiate a new Sciigo::Nagios object
    Then it should respond to the transport method
    And the transport should be the email up to the first colon
    And the contactemail should not start with the transport

  Scenario: Access Environment Variables
    Given I have a basic set of environment variables
    When I instantiate a new Sciigo::Nagios object
    Then I should be able to access the variables with []
    And with the variables name as method name
    And via the fetch method

  Scenario: Case insensitive key access
    Given I have a basic set of environment variables
    When I instantiate a new Sciigo::Nagios object
    Then the case of a key should not matter

  Scenario: Differentiate host notifications
    Given I have a basic set of environment variables
    And I want a host notification
    When I instantiate a new Sciigo::Nagios object
    Then the category method should respond with :host
    And the host method should return true

  Scenario: Differentiate service notifications
    Given I have a basic set of environment variables
    And I want a service notification
    When I instantiate a new Sciigo::Nagios object
    Then the category method should respond with :service
    And the service method should return true
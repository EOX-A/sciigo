Feature: Sciigo
  Scenario: Configuration Directory
    Given I have included the sciigo module
    When I ask for the configuration directory
    Then I should get File.expand_path('../config/')

  Scenario: Configuration
    Given I have included the sciigo module
    When I ask for the configuration data
    Then I should get a Hash
    And it should include a log key
    And this hash should include a vars key

  Scenario: Logging
    Given I have included the sciigo module
    When I ask for the logger
    Then I should get a object which responds to the log method
    
Feature: Test nagios data collection
  
  Scenario: Nagios Environment Variables
    Given I have an array of Environment Variables
    When I instantiate a new Nagios class
    Then the class should provides wrappers for nagios variables

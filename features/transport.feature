Feature: Transport
  Scenario: Instantiate BasicTransport
    Given I have a BasicTransport
    When I try to use the send method
    Then I should get a Sciigo::Transport::Error exception

  Scenario: Instantiate a transport with an empty name
    When I call Sciigo::Transport.new with an empty name
    Then I should get a Sciigo::Transport::Error exception

  Scenario: Instantiate a named transport
    Given I have an existing transport's name
    When I call Sciigo::Transport.new with this transport name
    Then I should get a corresping transport

  Scenario: Instantiate an unknown transport
    Given I have an unknown transport's name
    When I call Sciigo::Transport.new with this transport name
    Then I should get a Sciigo::Transport::UnknownTransport error
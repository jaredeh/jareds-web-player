Feature:  Host tracking
  In order to track what each served up host is doing
  I want to ensure we have a Host object

  Scenario: Adding hostname
    Given I create a new Host object with the hostname "fred.d.com" the first parameter
    When I read from the .hostname parameter
    Then It should return a hostname of "fred.d.com"

  Scenario: Adding port
    Given I create a new Host object with the port "3020" the second parameter
    When I read from the .port parameter
    Then It should return a port number of "3020"

  Scenario: Acknowledging hits
    Given a generic Host object
    When I record a path with .hit("/foo")
    Then .log should return an array with 1 entries

  Scenario: Recording 1 hit
    Given a generic Host object
    When I record a path with .hit("/foo")
    Then the 0 entry of .log should be "/foo"

  Scenario: Recording 3 hits
    Given a generic Host object
    When I record a path with .hit("/foo")
    And I record a path with .hit("/bar")
    And I record a path with .hit("/baz")
    Then the 0 entry of .log should be "/foo"
    And the 1 entry of .log should be "/bar"
    And the 2 entry of .log should be "/baz"

  Scenario: Getting Hot
    Given a generic Host object
    When I record a path with .hit("/foo")
    Then .heat should be 95 plus or minus 5

  Scenario: Getting cold
    Given a generic Host object
    When I record a path with .hit("/foo")
    And I wait 100 milliseconds
    Then .heat should be 66 plus or minus 10

  Scenario: Getting colder
    Given a generic Host object
    When I record a path with .hit("/foo")
    And I wait 200 milliseconds
    Then .heat should be 33 plus or minus 15

  Scenario: Getting absolute zero
    Given a generic Host object
    When I record a path with .hit("/foo")
    And I wait 310 milliseconds
    Then .heat should be 0 plus or minus 0
    
  Scenario: Heavy traffic
    Given a generic Host object
    When I record a path with .hit("/foo")
    And I record a path with .hit("/bar")
    And I record a path with .hit("/baz")
    Then .traffic should be 3
    And the 0 entry of .log should be "/foo"
    And the 1 entry of .log should be "/bar"
    And the 2 entry of .log should be "/baz"
    
  Scenario: One down in traffic
    Given a generic Host object
    When I record a path with .hit("/foo")
    And I wait 100 milliseconds
    And I record a path with .hit("/bar")
    And I wait 100 milliseconds
    And I record a path with .hit("/baz")
    And I wait 110 milliseconds
    Then .traffic should be 2
    And the 0 entry of .log should be "/bar"
    And the 1 entry of .log should be "/baz"
  
  Scenario: Two down in traffic
    Given a generic Host object
    When I record a path with .hit("/foo")
    And I wait 100 milliseconds
    And I record a path with .hit("/bar")
    And I wait 100 milliseconds
    And I record a path with .hit("/baz")
    And I wait 210 milliseconds
    Then .traffic should be 1
    And the 0 entry of .log should be "/baz"

  Scenario: No traffic
    Given a generic Host object
    When I record a path with .hit("/foo")
    And I wait 100 milliseconds
    And I record a path with .hit("/bar")
    And I wait 100 milliseconds
    And I record a path with .hit("/baz")
    And I wait 310 milliseconds
    Then .traffic should be 0
    And .log should return an array with 0 entries

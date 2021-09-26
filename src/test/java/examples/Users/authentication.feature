Feature: Generating Authentication token and saving to be used by other feature.

  Background:
    * url urlUserApp
    * def testUser = 'dipudan'
    * configure ssl = true


  Scenario: Get the authentication token.
    Given path '/v2/user' , testUser
    And header Content-Type = 'application/json'
    When method get
    Then status 200
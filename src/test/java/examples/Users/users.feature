Feature: User Creation

  Background:
    * url urlUserApp
    * def createUserBody = read('../resources/createUser.json')
    * def testUser = 'Loyal123'
    * configure logPrettyRequest = true
    * configure logPrettyResponse = true
    * configure ssl = true
    * def authentication = call read('authentication.feature')
    * def authenticationToken = authentication.response.id
    * def delay =
        """
        function(seconds){
          for(i = 0; i <= seconds; i++)
          {
            java.lang.Thread.sleep(1*1000);
            karate.log(i);
          }
        }
        """

  Scenario: Creating a new User
    Given path '/v2/user'
    * replace createUserBody
      | token      | value              |
      | UserName   | 'Loyal123'        |
      | FirstName  | 'Robert'           |
      | LastName   | 'Krishnan'         |
      | Email      | 'rb.kris@test.com' |
      | Password   | '****************' |
      | PhoneNumber| '9876543210'       |
    And request createUserBody
    * print authenticationToken
    And header Content-Type = 'application/json'
    When method post
    Then status 200


  Scenario: Get the user details and validate username & email.
    Given path '/v2/user', testUser
    And header Content-Type = 'application/json'
    * callonce delay 10
    When method get
    Then status 200
    And match response contains { username: 'Loyal123' ,  email: 'rb.kris@test.com' }

  Scenario: Update the user details using put.
    Given path '/v2/user',testUser
    * replace createUserBody
      | token      | value              |
      | UserName   | 'Loyal123'  |
      | FirstName  | 'Robertedit'       |
      | LastName   | 'Krishnanedit'     |
      | Email      | 'rb.kris@test.com' |
      | Password   | '****************' |
      | PhoneNumber| '9876543210'       |
    * print createUserBody
    And request createUserBody
    And header Content-Type = 'application/json'
    * callonce delay 10
    When method put
    Then status 200


  Scenario: Validate the update made in put.
    Given path '/v2/user',testUser
    And header Content-Type = 'application/json'
    * callonce delay 10
    When method get
    Then status 200
    And match response contains {firstName: 'Robertedit' }

  Scenario: Delete user using username.
    Given path '/v2/user', testUser
    * callonce delay 10
    When method delete
    Then status 200

  Scenario: Verify 404 is thrown while pulling by with deleted username.
    Given path '/v2/user', testUser
    And header Content-Type = 'application/json'
    When method get
    Then status 404
    And match response contains { 'message': 'User not found' }
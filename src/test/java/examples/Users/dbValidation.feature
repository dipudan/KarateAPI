Feature: Validating the details with database.

  Background:
    #Create JDBC connection with DbUtils java class
    * def configDB = {username : '' , password: '' , url: 'connection string' , driverClassName:''}
    * print configDB
    * def DbUtils = Java.type('example.util.DbUtils')
    * def db = new DbUtils(configDB)
    * def expectedResult = read('../resources/paintDetails.json)

  Scenario: Posting a data and verifying the data is inserted into database.
    * def user = db.readRows('Select * from mytable;')
    Then match user contains expectedResult
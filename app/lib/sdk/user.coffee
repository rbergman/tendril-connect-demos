{Resource} = require "./resource"

module.exports =

  User: class User extends Resource
  
    @path "/user/{user-id}",
      "user-id": "current-user"

    @can "load"
    
    @schema
      "user":
        "firstName": "string"
        "lastName": "string"
        "emailAddress": "string"
        "usingTemporaryPassword": "boolean"
        "userName": "string"
        "expert": "boolean"
        "authorId": "string"
    
    firstName: -> @value "user/firstName"

    lastName: -> @value "user/lastName"

    emailAddress: -> @value "user/emailAddress"
    
    usingTemporaryPassword: -> @value "user/usingTemporaryPassword"

    userName: -> @value "user/userName"

    expert: -> @value "user/expert"

    authorId: -> @value "user/authorId"

  UserProfile: class UserProfile extends Resource

    @path "/user/{user-id}/profile",
      "user-id": "current-user"

    @can "load"
    
    @schema
      "userProfile":
        "displayName": "string"
        "aboutMe": "string"
        "location": "string"
        "savingsGoal": "string"
        "picture": "string"
        "makeHomeDetailPublic": "boolean"
        "makeSavingsGoalPublic": "boolean"

    displayName: -> @value "userProfile/displayName"

    aboutMe: -> @value "userProfile/aboutMe"

    location: -> @value "userProfile/location"

    savingsGoal: -> @value "userProfile/savingsGoal"

    picture: -> @value "userProfile/picture"

    makeHomeDetailPublic: -> @value "userProfile/makeHomeDetailPublic"

    makeSavingsGoalPublic: -> @value "userProfile/makeSavingsGoalPublic"

  UserLocation: class UserLocation extends Resource

    @path "/user/{user-id}/account/{account-id}/location/{location-id}",
      "user-id": "current-user"
      "account-id": "default-account"
      "location-id": "default-location"

    @can "load"
    
    id: -> @value "location/@id"
    
    streetAddress: -> @value "location/streetAddress"
    
    city: -> @value "location/city"
    
    state: -> @value "location/state"
    
    postalCode: -> @value "location/postalCode"
    
    countryCode: -> @value "location/countryCode"
    
    timeZone: -> @value "location/timeZone"
    
    externalResidenceId: -> @value "location/externalResidenceId"

  UserLocationProfile: class UserLocationProfile extends Resource

    @path "/user/{user-id}/account/{account-id}/location/{location-id}/profile/{category}",
      "user-id": "current-user"
      "account-id": "default-account"
      "location-id": "default-location"
      "category": ""

    @can "load"

    # @properties [
    #   "locationProfile/householdCategory/numPeopleInAgeGroup1"
    #   "locationProfile/householdCategory/numPeopleInAgeGroup2"
    #   "locationProfile/householdCategory/numPeopleInAgeGroup3"
    #   "locationProfile/householdCategory/numPeopleInAgeGroup4"
    #   "locationProfile/householdCategory/stayHomeOnWeekdays"
    #   "locationProfile/householdCategory/occupations"
    #   "locationProfile/homeDetailCategory/dwellingType"
    #   "locationProfile/homeDetailCategory/dwellingSize"
    #   "locationProfile/homeDetailCategory/hvacCoolingConfig"
    #   "locationProfile/homeDetailCategory/hvacHeatingConfig"
    #   "locationProfile/homeDetailCategory/poolPump"
    #   "locationProfile/relayDetailCategory/relayDetail"
    
  UserAccount: class UserAccount extends Resource

    @path "/user/{user-id}/account/{account-id}",
      "user-id": "current-user"
      "account-id": "default-account"

    @can "load"
    
    @schema
      "account":
        "@id": "string"
        "@externalAccountId": "string"
    
    id: -> @value "account/@id"
    
    externalAccountId: -> @value "account/@externalAccountId"

{Resource} = require "./resource"

module.exports =

  NeighborsConsumption: class NeighborsConsumption extends Resource

    @path "/user/{user-id}/account/{account-id}/comparison/myneighbors/{resolution}",
      "user-id": "current-user"
      "account-id": "default-account"
      "resolution": "MONTHLY"
    
    @matrix "from to"

    @can "load"
  
  BaselineActualConsumption: class BaselineActualConsumption extends Resource
    
    @path "/user/{user-id}/account/{account-id}/comparison/baselineactual/{resolution}",
      "user-id": "current-user"
      "account-id": "default-account"
      "resolution": "MONTHLY"
    
    @matrix "asof"

    @can "load"

{Resource} = require "./resource"

module.exports =

  MeterReadings: class MeterReadings extends Resource

    @path "/meter/read"

    @matrix "external-account-id from to limit-to-latest source"

    @can "load"

  Consumption: class Consumption extends Resource

    @path "/user/{user-id}/account/{account-id}/consumption/{resolution}",
      "user-id": "current-user"
      "account-id": "default-account"
      "resolution": "MONTHLY"

    @matrix "from to limit-to-latest include-submetering-devices"

    @can "load"

  ProjectedConsumption: class ProjectedConsumption extends Resource

    @path "/user/{user-id}/account/{account-id}/consumption/{resolution}/projection",
      "user-id": "current-user"
      "account-id": "default-account"
      "resolution": "MONTHLY"

    @matrix "source"

    @can "load"

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


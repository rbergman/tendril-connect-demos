{Resource} = require "./resource"

module.exports =

  Devices: class Devices extends Resource

    @path "/user/{user-id}/account/{account-id}/location/{location-id}/network/default-network/device",
      "user-id": "current-user"
      "account-id": "default-account"
      "location-id": "default-location"

    @matrix "include-extended-properties"

    @can "load"

    @schema
      "devices":
        "device*":
          "deviceId": "string"
          "networkId": "string"
          # @todo, category is an array! -> "category*": "string"
          "category": "string"
          "name": "string"
          "marketingName": "string"
          "extendedProperty*":
            "namespace": "string"
            "name": "string"
            "value": "string"

    devices: ->
      devices = @data.devices?.device or []
      for device in devices when device.extendedProperty
        device.extendedProperty = device.extendedProperty.sort (a, b) ->
          akey = (a.namespace or "0") + a.name
          bkey = (b.namespace or "0") + b.name
          (bkey < akey) - (akey < bkey)
      devices
    
    deviceById: (id) ->
      one = (device for device in @devices() when device.deviceId is id)
      if one.length is 1 then one[0] else undefined
    
    devicesByCategory: (category) ->
      device for device in @devices() when device.category is category
    
    firstDeviceByCategory: (category) ->
      some = @devicesByCategory category
      if some.length > 0 then some[0] else undefined

  DeviceConsumption: class DeviceConsumption extends Resource

    @path "/user/{user-id}/account/{account-id}/location/{location-id}/device/{device-id}/consumption/{resolution}",
      "user-id": "current-user"
      "account-id": "default-account"
      "location-id": "default-location"
      "resolution": "MONTHLY"

    @matrix "from to limit-to-latest include-extended-properties"

    @can "load"


{ActionCommand, ActionResult, Action} = require "./action_request"

exports.BuildingModelSimulationCommand = class BuildingModelSimulationCommand extends ActionCommand
  
  @createPath = "/user/{user-id}/account/{account-id}/location/{location-id}/buildingmodel-action"
  
  @schema
    "buildingModelSimulationRequest":
      "@xmlns": "string"
      "@requestId": "string"
      "profileItemOverrideList":
        "profileItem*":
          "name": "string"
          "value": "string"
      "fuelUnitOverrideList":
        "fuelUnitOverride*":
          "fuelType": "string"
          "fuelUnit": "string"

  @create: (options={}) ->
    body = options.body =
      "buildingModelSimulationRequest":
        "@xmlns": "http://platform.tendrilinc.com/tnop/extension/ems/buildingmodel"
    if options.profileItemOverrides and Object.keys(options.profileItemOverrides).length > 0
      items = []
      body["profileItemOverrideList"] = "profileItem": items
      items.push {name: k, value: v} for own k, v of options.profileItemOverrides
    if options.fuelUnitOverrides and Object.keys(options.fuelUnitOverrides).length > 0
      units = []
      body["fuelUnitOverrideList"] = "fuelUnitOverride": units
      units.push {fuelType: k, fuelUnit: v} for own k, v of options.fuelUnitOverrides
    super options

exports.BuildingModelSimulationResult = class BuildingModelSimulationResult extends ActionResult
  
  @path "/buildingmodel-action/{request-id}"

  @schema
    "buildingModelSimulationRequest":
      "@xmlns": "string"
      "@requestId": "string"
      "result":
        "energyUseList":
          "@resolution": "string"
          "@fromDate": "datetime"
          "@toDate": "datetime"
          "energyUse*":
            "@endUse": "string"
            "@fuelType": "string"
            "component*":
              "@fromDate": "datetime"
              "@toDate": "datetime"
              "consumption": "float"
              "unit": "string"
              "cost": "float"
  
  energyUseList: ->
    result = @result()
    result.energyUseList if result
  
  resolution: ->
    list = @energyUseList()
    list["@resolution"] if list
  
  from: ->
    list = @energyUseList()
    list["@fromDate"] if list
  
  to: ->
    list = @energyUseList()
    list["@toDate"] if list
  
  energyUseCount: ->
    list = @energyUseList()
    if list and list.energyUse then list.energyUse.length else 0

  energyUse: (i) ->
    list = @energyUseList()
    if list and list.energyUse
      use = list.energyUse[i]
      endUse: ->
        use["@endUse"] if use
      fuelType: ->
        use["@fuelType"] if use
      componentCount: ->
        if use and use.component then use.component.length else 0
      component: (j) ->
        if use and use.component
          comp = use.component[j]
          from: ->
            comp["@fromDate"] if comp
          to: ->
            comp["@toDate"] if comp
          consumption: ->
            comp.consumption if comp
          unit: ->
            comp.unit if comp
          cost: ->
            comp.cost if comp

exports.BuildingModelSimulation = class BuildingModelSimulation extends Action

  @command BuildingModelSimulationCommand
  @result BuildingModelSimulationResult

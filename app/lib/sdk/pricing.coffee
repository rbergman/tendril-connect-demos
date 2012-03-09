{Resource} = require "./resource"

module.exports =

  PricingProgram: class PricingProgram extends Resource
  
    @path "/user/{user-id}/account/{account-id}/pricing/current-pricing-program",
      "user-id": "current-user"
      "account-id": "default-account"

    @can "load"
    
    @schema
      "pricingProgram":
        "name": "string"
        "id": "string"
        "description": "string"
        "active": "boolean"
        "schedules":
          "schedule*":
            "id": "string"
            "name": "string"
            "effectiveDate": "datetime"
            "switchPointDefinition":
              "content": "string"
            "scheduleRatesList":
              "scheduleRates*":
                "id": "string"
                "scheduleName": "string"
                "effectiveDate": "datetime"
                "consumptionBaseline": "float"
                "rateList":
                  "rate*":
                    "@key": "string"
                    "label": "string"
                    "priceTier*":
                      "energyPrice": "float"
                      "deliveryCharge": "float"
        "holidays":
          "holiday*":
            "@name": "string"
            "$": "datetime"
    
    program: -> @data.pricingProgram

    schedules: ->
      MONTHS = "January February March April May June July August September October November December".split " "
      scheduleFor = (json, si) ->
        schedule = {}
        schedule[k] = v for own k, v of json when k isnt "switchPointDefinition"
        spd = schedule.switchPointDefinition = new Array 12
        for line in json.switchPointDefinition.content.split "\n"
          cols = line.split ","
          mi = MONTHS.indexOf cols[0]
          month = spd[mi] = spd[mi] or {}
          month[cols[1]] = cols.slice 2
        schedule
      scheduleFor json, i for json, i in @value("pricingProgram/schedules/schedule") or []
    
    holidays: ->
      holidayFor = (json) -> holiday = name: json["@name"], date: json["$"]
      holidayFor json for json in @value("pricingProgram/holidays/holiday") or []
    
  PricingSchedule: class PricingSchedule extends Resource

    @path "/account/{account-id}/pricing/schedule",
      "account-id": "default-account"
    
    @matrix "from to"

    @can "load"

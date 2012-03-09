module.exports =

  jsonFrom: (model) ->
    readingType = model.data.feed.entry[0].content.ReadingType
    units = readingType.powerOfTenMultiplier
    units = if units is "3" then "kWH" else "WH"
    json =
      cost: data: [], units: "$"
      consumption: data: [], units: units
      rate: data: [], units: "$/#{units}"
    blocks = model.data.feed.entry[1].content.IntervalBlock
    blocks = [blocks] if blocks not instanceof Array
    for block in blocks
      for reading in block.IntervalReading
        millis = reading.timePeriod.start * 1000
        cost = parseInt(reading.cost) / 100000
        json.cost.data.push [millis, cost]
        consumption = parseInt(reading.value)
        json.consumption.data.push [millis, consumption]
        rate = cost / consumption
        json.rate.data.push [millis, rate]
    JSON.stringify json

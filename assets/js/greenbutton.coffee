$ ->

  el = $("#graph")
  if el[0]
    json = $("#json").html()
    json = if json then JSON.parse json else {cost: {data: [], units: "$"}, consumption: {data: [], units: "kWH"}, rate: {data: [], units: "$/kWH"}}
    costSeries = data: json.cost.data, label: "Cost (#{json.cost.units})"
    consumptionSeries = data: json.consumption.data, label: "Consumption (#{json.consumption.units})", yaxis: 2
    rateSeries = data: json.rate.data, label: "Estimated Rate (#{json.rate.units})", yaxis: 3
    dollars = (v, axis) -> json.cost.units + v.toFixed(axis.tickDecimals)
    wh = (v, axis) -> v.toFixed(axis.tickDecimals) + " " + json.consumption.units
    dpwh = (v, axis) -> return v.toFixed(axis.tickDecimals) + " " + json.rate.units
    config =
      xaxes: [mode: "time"]
      yaxes: [
        {min: 0, alignTicksWithAxis: 1, position: "right", tickFormatter: dpwh}
        {min: 0, alignTicksWithAxis: 1, tickFormatter: wh}
        {min: 0, tickFormatter: dollars}
      ],
      legend: position: "sw"
    $.plot el, [rateSeries, consumptionSeries, costSeries], config

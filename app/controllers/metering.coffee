exports.protected = true

exports.metering = require("./subpage_controller")
  name: "metering"
  title: "Metering Demos"
  subpages: [
    {name: "readings", title: "Meter Readings"}
    {name: "consumption", title: "Cost & Consumption"}
    {name: "projection", title: "Projected Cost & Consumption"}
  ]

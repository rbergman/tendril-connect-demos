exports.protected = true

exports.pricing = require("./subpage_controller")
  name: "pricing"
  title: "Pricing Demos"
  subpages: [
    {name: "program", title: "Program"}
    {name: "schedule", title: "Schedule"}
  ]

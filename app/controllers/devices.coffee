exports.protected = true

exports.devices = require("./subpage_controller")
  name: "devices"
  title: "Device Demos"
  subpages: [
    {name: "discovery", title: "Discovery"}
    {name: "consumption", title: "Cost & Consumption"}
    {name: "plug", title: "Smart Plug", hidden: true}
    {name: "plug_mode", title: "Set Smart Plug Mode", hidden: true}
    {name: "thermostat", title: "Thermostat", hidden: true}
    {name: "thermostat_data", title: "Set Thermostat Data", hidden: true}
    {name: "thermostat_program", title: "Thermostat Program", hidden: true}
    {name: "thermostat_hold", title: "Thermostat Hold Status", hidden: true}
    {name: "generic", title: "Generic Actions", hidden: true}
  ]

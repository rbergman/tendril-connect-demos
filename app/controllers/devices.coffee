exports.protected = true

exports.devices = require("./subpage_controller")
  name: "devices"
  title: "Device Demos"
  subpages: [
    {name: "discovery", title: "Discovery"}
    {name: "consumption", title: "Cost & Consumption"}
    {name: "thermostat", title: "Thermostat Data"}
    {name: "thermostat_program", title: "Thermostat Program Data"}
    {name: "thermostat_hold", title: "Thermostat Hold Status"}
    {name: "plug", title: "Smart Plug Data"}
    {name: "generic", title: "Generic Actions"}
  ]

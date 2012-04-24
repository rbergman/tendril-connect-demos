exports.protected = true

exports.devices = require("./subpage_controller")
  name: "devices"
  title: "Device Demos"
  subpages: [
    {name: "discovery", title: "Discovery"}
    {name: "consumption", title: "Cost & Consumption"}
    {name: "plug", title: "Smart Plug"}
    {name: "plug_mode", title: "Set Smart Plug Mode", hidden: true}
    {name: "thermostat", title: "Thermostat"}
    {name: "thermostat_program", title: "Thermostat Program"}
    {name: "thermostat_hold", title: "Thermostat Hold Status"}
    #{name: "generic", title: "Generic Actions"}
  ]

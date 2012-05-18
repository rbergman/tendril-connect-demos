for file in "building_action devices device_action greenbutton metering plug pricing thermostat thermostat_program thermostat_hold user".split " "
  exports[k] = v for own k, v of require "./#{file}"

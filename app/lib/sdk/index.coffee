for file in "comparisons devices device_action greenbutton metering plug pricing thermostat thermostat_program user".split " "
  exports[k] = v for own k, v of require "./#{file}"

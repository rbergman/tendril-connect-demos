{Resource} = require "./resource"

exports.GreenButton = class GreenButton extends Resource
  
  @path "/greenbutton"
  
  @query "from to resolution max-results"

  @can "load"

  @schema # @todo add schema and then drop array checks in green_button json helper method

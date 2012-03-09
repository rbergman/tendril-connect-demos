exports.protected = true

exports.user = require("./subpage_controller") 
  name: "user"
  title: "User Demos"
  subpages: [
    {name: "info", title: "Information"}
    {name: "profile", title: "Profile"}
    {name: "account", title: "Account"}
    {name: "location", title: "Location"}
    {name: "location_profile", title: "Location Profile"}
  ]

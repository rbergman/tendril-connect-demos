module.exports =
  app:
    secret: "honey badger don't give a care"
  oauth:
    trace: false
    consumer:
      url: "http://localhost:{port}"
      id: "6b26d68b3541a7e491848f02560c53c1"
      secret:"981cea3aee34db568cfe1f0e9013822d"
      scope: "account consumption device"
      threshold: 60
    provider:
      url: "https://dev.tendrilinc.com"
      authorize: "/oauth/authorize"
      accessToken: "/oauth/access_token"
      logout: "/oauth/logout"
      route: "sandbox"

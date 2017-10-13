technoridesApp.controller 'signupCtrl' ,['$scope','$settings','$translate','$http','$api','$apiAdapter','$apiHandler','$interval','$filter',($scope, $settings, $translate, $http, $api, $apiAdapter, $apiHandler, $interval, $filter) ->

  $api.setAdapter($apiAdapter)
  $api.setHandler($apiHandler)
  # Used by common
  $scope.settings = $settings
  $scope.settings.unstableVersion = false
  $scope.plan = 3
  $scope.step = 1
  $pricingPerDriver = {}
  $minimumDrivers = {}

  $scope.close = ->
    $scope.opened = false

  $scope.open = (event) ->
    if event?
      event.preventDefault()
      event.stopPropagation()
    $scope.opened = !$scope.opened

  $plans = {}
  $scope.totalPrice = 999

  $scope.backToStep = (number) ->
    $scope.step = number

  $scope.checkStep1 = ->
    $scope.step = 2

  $scope.checkStep2 = ->
    $scope.step = 3

  $scope.checkStep3 = (user, plan, price) ->
    $api.send("signUp", {user:user, plan: plan, totalPrice: price})
    $api.send("mailToUser", user, ->
      $scope.step = 4
    )

  $scope.user = {}
  $scope.user.company = {}
  $scope.user.company.region = "usa"
  $usa = ""
  $europe = ""
  $latam =  ""
  $translate(['USA','Europe','LATAM']).then( (text) ->
    $usa = text.USA
    $europe = text.Europe
    $latam = text.LATAM
    $scope.icons = [
      {
        value: "usa"
        label: "<div class='usa'></div> #{$usa}"
      }
      {
        value: "europe"
        label: "<div class='europe'></div> #{$europe}"
      }
      {
        value: "latam"
        label: "<div class='latam'></div> #{$latam} "
      }
    ]
  )

  $http.get("/common/json/pricing.json")
  .success (response) ->
    $pricingPerDriver = response.pricePerDriver
    $minimumDrivers = response.minimumDrivers
    $scope.minimumDrivers  = response.minimumDrivers
    $plans = response.plans
  $scope.pricePerDriver = 0



  $scope.changePricePerDriver = (drivers, plan) ->
    availablePlans =
        1: "basic"
        2: "advanced"
        3: "premium"
        4: "enterprise"
    plan = availablePlans[plan]
    if drivers?

      prices = {}
      min = 0
      if $scope.user.company.region is "usa" or $scope.user.company.region is "europe"
        prices = $pricingPerDriver.europe
        min = $minimumDrivers.europe+1
      else
        prices = $pricingPerDriver.latam
        min = $minimumDrivers.latam+1
      price = Object.keys prices
      .map (value) ->
        if value <= drivers+min
          return parseInt value
        else
          return undefined
      .filter Number
      .sort (a, b) ->
        a - b
      .pop()

      if price is undefined
        price = 0
      else
        $scope.pricePerDriver = prices[price][plan]
        $scope.extraByDriver = (drivers ) * prices[price][plan]
        $scope.totalPrice = $plans[plan] + $scope.extraByDriver
    else
      $scope.totalPrice = $plans[plan]
      $scope.extraByDriver = 0

]

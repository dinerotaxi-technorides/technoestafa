technoridesApp.controller 'technoridesCtrl' , ($scope, $api, $apiAdapter, $apiHandler, $http, $settings, $location, $translate, $cookieStore, $message, $map, $timeout) ->
  $map.chooseProvider("mapbox")
  # Used by common
  $scope.settings                 = $settings
  $scope.settings.unstableVersion = false

  $scope.error                    = $message.error
  $scope.success                  = $message.success
  $scope.warning                  = $message.warning

  $api.setAdapter($apiAdapter)
  $api.setHandler($apiHandler)

  $scope.emailAttributes          = {}
  $scope.freeTrial                =
    fleet : 100

  $scope.countries = [ "United States","Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua  Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia  Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canadá","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre  Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts  Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad  Tobago","Tunisia","Turkey","Turkmenistan","Turks  Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]
  $scope.flags     = []
  # We set $map provider
  $timeout( ->
      $map.initialize "map_canvas",
        latitude    : 37.744719
        longitude   : -122.483596
        zoom        : 15
        mapTypeId   : "mapbox.streets"
        zoomControl : false

      # Company
      options =
        position  : $map.latLng({lat: 37.744719, lng: -122.483596})
        icon      : "technorides/assets/contactmarker.png"
        doCluster : false
        visible   : true
        draggable : false
        markerId  : "home"
      $map.addMarker("company", "home", options)
      $map.disableMovement()
    ,
      1000
  )
  # Set language
  if $cookieStore.get("lang")?
    $scope.lang = $cookieStore.get("lang")
  else
    $scope.lang = "en"

  # Language supported?
  $scope.lang = "en" unless $.inArray $scope.lang, ["en", "es", "fr"]
  $translate.use($scope.lang)


  $scope.changeLanguage = (lang) ->
    $translate.use(lang)
    $cookieStore.remove("lang")
    $cookieStore.put("lang", lang)
    $scope.lang = lang


  $scope.sendEmail = (emailAttributes) ->
    emailAttributes.origin = "(via -Contact Us- en technorides.com)"
    emailAttributes.reason = "Contacto desde Web"
    $api.send "sendEmail", emailAttributes, ->
      $scope.emailAttributes =
        name : " "
        email : " "
        phone: " "
        country : emailAttributes.country
        message : " "


  $scope.carTotalProm = (total) ->
    value = Math.floor (total*11)/2000

    for car in $scope.lightDrivers
      if car.id < value
        $scope.lightDrivers[car.id].val = "on"
      else
        $scope.lightDrivers[car.id].val = "off"


  $scope.openFreeTrial = (plan) ->
    $scope.plan = plan
    $(".free-trial").modal("show")
    false


  $scope.hideFreeTrial = ->
    $(".free-trial").modal("hide")
    false


  $scope.showProwduct = (num) ->
    $(".show#{num}").modal("show")
    false


  $scope.sendFreeTrial = (freeTrial, plan) ->

    freeTrial.origin = "(via -Free Trial- en technorides.com)"
    freeTrial.plan = plan

    $api.send "freeTrial", freeTrial, ->
      lastCountry = $scope.freeTrial.country
      $scope.freeTrial = {}
      $scope.freeTrial.country = lastCountry


  # This makes the navbar to autoclose when click on a link (on mobile display)
  $(".navbar-nav li a").click (event) ->
    # if its mobile
    toggle = $(".navbar-toggle").is(":visible")
    $(".navbar-collapse").collapse "hide"  if toggle
    false


  $("#login").click  ->
    window.location = "/login"


  $scope.freeTrial.region = "usa"
  $usa                    = ""
  $europe                 = ""
  $latam                  = ""


  $translate(['USA','Europe','LATAM']).then (text) ->
    $usa         = text.USA
    $europe      = text.Europe
    $latam       = text.LATAM

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

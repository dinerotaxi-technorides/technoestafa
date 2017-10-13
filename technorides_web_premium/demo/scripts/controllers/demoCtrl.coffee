technoridesApp.controller 'demoCtrl', ($scope, $cookieStore, $message, $http, $api, $apiAdapter, $apiHandler ,$settings) ->

  $api.setAdapter($apiAdapter)
  $api.setHandler($apiHandler)
  $scope.settings = $settings
  language         = navigator.language.replace /-.+/, ""
  $scope.lang      = "en" unless $.inArray language, ["en", "es", "fr"]
  $scope.error     = $message.error
  $scope.warning   = $message.warning
  $scope.success   = $message.success


  # if could not get navigator lang
  if typeof $scope.lang is "undefined"
    # Set language
    if $cookieStore.get("lang")?
      $scope.lang = $cookieStore.get("lang")
    else
      $scope.lang = "en"
  $scope.resetForm = ->
    $scope.demo =
      fleet : 100
    $scope.countries = [ "Estados Unidos","Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua  Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia  Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canadá","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre  Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts  Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad  Tobago","Tunisia","Turkey","Turkmenistan","Turks  Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]

    # $scope.flags = []
    # $http.get("/common/json/countries.json")
    # .success (response) ->
    #   for country in response
    #     flagName = country.name.toLocaleLowerCase().split(' ').join('_')
    #     flag = "http://flags.redpixart.com/img/#{flagName}_preview.gif"
    #     if country.name is geoplugin_countryName()
    #       isCountry = true
    #     else
    #       isCountry = false
    #     if $scope.lang != "en"
    #       if country.translations[$scope.lang]?
    #         $scope.countries.push country.translations[$scope.lang]
    #         if isCountry
    #           $scope.demo.country = country.translations[$scope.lang]
    #     else
    #       $scope.countries.push country.name
    #       $scope.flags.push flag
    #       if isCountry
    #         $scope.demo.country = country.name

    date = new Date()
    $scope.months = []
    e = 1
    while e < 13
      $scope.months.push e
      e++
    $scope.years = []

    i = 2015

    while i < 2028
      $scope.years.push(i)
      i++
    $scope.demo.expiration = {}

    $scope.demo.expiration.year = date.getFullYear()
    $scope.demo.expiration.month = date.getMonth()
  $scope.resetForm()
  $scope.sendEmail = (demo) ->
    $scope.sending = true
    $(".send").modal("show")
    $api.send "sendEmail", demo, (response) ->
      if response.status is 100
        $scope.sending = false
        $scope.sended = true
        $scope.resetForm()
        $scope.demos.submited = false
      else
        $scope.sending = false
        $scope.errorSend = true
      console.log response

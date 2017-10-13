technoridesApp.controller 'landingCtrl' , ['$scope','$settings', '$api', '$apiHandler', '$apiAdapter', '$location', '$window', '$http', '$message', ($scope, $settings, $api, $apiHandler, $apiAdapter, $location, $window, $http, $message) ->
  $api.setHandler($apiHandler)
  $api.setAdapter($apiAdapter)

  language = navigator.language.replace /-.+/, ""
  $scope.lang = language
  $scope.lang = "en" unless $.inArray language, ["en", "es", "fr"]
  $scope.error     = $message.error
  $scope.warning   = $message.warning
  $scope.success   = $message.success
  $scope.freeTrial =
    fleet : 100
  # control version
  $scope.settings = $settings

  $scope.countries = ["United States","Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua  Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia  Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canadá","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre  Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts  Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad  Tobago","Tunisia","Turkey","Turkmenistan","Turks  Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]
  $scope.flags = []
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
  #           $scope.freeTrial.country = country.translations[$scope.lang]
  #     else
  #       $scope.countries.push country.name
  #       $scope.flags.push flag
  #       if isCountry
  #         $scope.freeTrial.country = country.name

  $scope.sendTrial = (mail) ->
    mail.origin = "(Por MailChimp desde Landing 2)"
    mail.plan = "ADWORDS LANDING 2"
    $api.send 'freeTrial', mail, ->
      location.href = "/thankyou.html##{$scope.lang}"
      # $location.path "/thankyou"
      # $http.get "http://www.googleadservices.com/pagead/conversion/959494099/?label=8BInCKPepVcQ0-_CyQM&amp;guid=ON&amp;script=0"
      # $scope.showThankYou = true

  # $scope.showThankYou   = $location.path() is "/thankyou"
  # $scope.acceptThankYou = ->
  #   $window.location.href = "/"
]

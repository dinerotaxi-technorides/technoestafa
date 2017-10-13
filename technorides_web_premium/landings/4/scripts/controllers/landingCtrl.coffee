technoridesApp.controller 'landingCtrl',($scope, $settings, $api, $apiHandler, $apiAdapter, $http, $message,$cookieStore,$location, $window, $timeout) ->

  $api.setHandler($apiHandler)
  $api.setAdapter($apiAdapter)
  preLang          = window.navigator.language;
  $scope.lang      = preLang.replace /-.+/, ""
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

  $scope.countries =  [ "United States","Afghanistan","Albania","Algeria","Andorra","Angola","Anguilla","Antigua  Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia  Herzegovina","Botswana","Brazil","British Virgin Islands","Brunei","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canadá","Cape Verde","Cayman Islands","Chad","Chile","China","Colombia","Congo","Cook Islands","Costa Rica","Cote D Ivoire","Croatia","Cruise Ship","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Estonia","Ethiopia","Falkland Islands","Faroe Islands","Fiji","Finland","France","French Polynesia","French West Indies","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guam","Guatemala","Guernsey","Guinea","Guinea Bissau","Guyana","Haiti","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Isle of Man","Israel","Italy","Jamaica","Japan","Jersey","Jordan","Kazakhstan","Kenya","Kuwait","Kyrgyz Republic","Laos","Latvia","Lebanon","Lesotho","Liberia","Libya","Liechtenstein","Lithuania","Luxembourg","Macau","Macedonia","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Mauritania","Mauritius","Mexico","Moldova","Monaco","Mongolia","Montenegro","Montserrat","Morocco","Mozambique","Namibia","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Palestine","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russia","Rwanda","Saint Pierre  Miquelon","Samoa","San Marino","Satellite","Saudi Arabia","Senegal","Serbia","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","South Africa","South Korea","Spain","Sri Lanka","St Kitts  Nevis","St Lucia","St Vincent","St. Lucia","Sudan","Suriname","Swaziland","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Timor L'Este","Togo","Tonga","Trinidad  Tobago","Tunisia","Turkey","Turkmenistan","Turks  Caicos","Uganda","Ukraine","United Arab Emirates","United Kingdom","Uruguay","Uzbekistan","Venezuela","Vietnam","Virgin Islands (US)","Yemen","Zambia","Zimbabwe"]

  $scope.flags = []


  # control version
  $scope.settings = $settings

  $scope.sendTrial = (mail) ->
    mail.origin = "Desde Nueva Landing 4"
    $api.send 'freeTrial', mail, ->
      # location.href = "/thankyou.html##{$scope.lang}"
      # $location.path "/thankyou"
      # $http.get "http://www.googleadservices.com/pagead/conversion/959494099/?label=8BInCKPepVcQ0-_CyQM&amp;guid=ON&amp;script=0"
      # $scope.showThankYou = true

  # $scope.showThankYou   = $location.path() is "/thankyou"
  # $scope.acceptThankYou = ->
  #   $window.location.href = "/"

    # $('#headquarters-map').gMap
    #   latitude: 37.7445663
    #   longitude: -122.4879734
    #   maptype: 'ROADMAP'
    #   zoom: 15
    #   markers: [ {
    #     latitude: 37.7445663
    #     longitude: -122.4879734
    #     icon:
    #       image: 'assets/icons/map-icon.png'
    #
    #   styles: [
    #     {
    #       'featureType': 'all'
    #       'elementType': 'labels.text.fill'
    #       'stylers': [
    #         { 'saturation': 36 }
    #         { 'color': '#000000' }
    #         { 'lightness': 40 }
    #       ]
    #     }
    #     {
    #       'featureType': 'all'
    #       'elementType': 'labels.text.stroke'
    #       'stylers': [
    #         { 'visibility': 'on' }
    #         { 'color': '#000000' }
    #         { 'lightness': 16 }
    #       ]
    #     }
    #     {
    #       'featureType': 'all'
    #       'elementType': 'labels.icon'
    #       'stylers': [ { 'visibility': 'off' } ]
    #     }
    #     {
    #       'featureType': 'administrative'
    #       'elementType': 'geometry.fill'
    #       'stylers': [
    #         { 'color': '#000000' }
    #         { 'lightness': 20 }
    #       ]
    #     }
    #     {
    #       'featureType': 'administrative'
    #       'elementType': 'geometry.stroke'
    #       'stylers': [
    #         { 'color': '#000000' }
    #         { 'lightness': 17 }
    #         { 'weight': 1.2 }
    #       ]
    #     }
    #     {
    #       'featureType': 'administrative'
    #       'elementType': 'labels'
    #       'stylers': [ { 'visibility': 'off' } ]
    #     }
    #     {
    #       'featureType': 'administrative.country'
    #       'elementType': 'all'
    #       'stylers': [ { 'visibility': 'simplified' } ]
    #     }

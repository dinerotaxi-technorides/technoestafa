technoridesApp.factory "$versionDetector", ["$settings", "$interval", "$timeout", "$http", "$message", "$translate", ($settings, $interval, $timeout, $http, $message, $translate) ->
  $interval ->
    $http.get("/common/scripts/settings.js?nocache=#{new Date()}").success (response) ->
      # Getting version
      version = response.match(/version[^,]+/)[0].replace(" ", "").split(":")[1]
      $versionDetector.version = version.substr(1, version.length - 2)

      if (not $versionDetector.messageShown) and ($settings.version isnt null and $settings.version isnt $versionDetector.version)
        $translate(["newVersionMessage"]).then (translations) ->
          $message.warning.show translations.newVersionMessage
        $versionDetector.messageShown = true
  ,
    $settings.intervals.versionDetector
  ,
    0
  ,
    true


  $versionDetector =
    version      : null
    messageShown : false


]

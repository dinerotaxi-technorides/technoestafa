angular.module('timer', []).filter('timer', ->

  (input) ->

    minutes = input / 60

    hours   = parseInt minutes / 60
    hours = "0#{hours}" if 10 > hours

    minutes = parseInt Math.abs minutes % 60
    minutes = "0#{minutes}" if 10 > minutes

    seconds = parseInt Math.abs input % 60
    seconds = "0#{seconds}" if 10 > seconds

    "#{hours}:#{minutes}:#{seconds}"
)

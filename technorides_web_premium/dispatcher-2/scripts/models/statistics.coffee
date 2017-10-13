technoridesApp.factory '$statistics', ['$statistics.adapter', '$translate', '$drivers', '$timeout', '$map', '$interval', ($api, $translate, $drivers, $timeout, $map, $interval) ->

  $statistics =
    passengers :
      amount : 0
    counters : {}
    status   : {}
    earnings : 0
    drivers   :
      total       : 0
      online      : 0
      intravel    : 0
      offline     : 0
      disconnected: 0
    init : () ->
      @.getPassengers()
      @.getCounters()
      @.getOperationsByStatus()
      @.getOperationsByDevice()
      @.getOperationsByDate()
      @.getOperationsEarnings()
      $timeout(
        ->
          $statistics.getDrivers()
        ,
          5000
      )
    getPassengers : ->
      $api.getPassengers
        done : (amount) ->
           $statistics.passengers.amount = amount
    getCounters : ->
      $api.getCounters
        done : (counters) ->
          $statistics.counters = counters
    getOperationsByStatus : () ->
      $api.getOperationsByStatus
        done : (response) ->
          $statistics.status = response
    getOperationsEarnings : () ->
      $api.getOperationsEarnings
        done : (response) ->
          $statistics.earnings = response.amount
    getOperationsByDevice : () ->
      $api.getOperationsByDevice
        done : (response) ->
          $translate(['Web', 'Android', 'Others']).then (translate) ->
            m6 = new Morris.Donut(
              element: "donut-chart2"
              data: [
                {
                  label: translate.Web
                  value: response.web
                }
                {
                  label: translate.Android
                  value: response.android
                }
                {
                  label: translate.Others
                  value: response.others
                }
              ]
              colors: [
                "#428bca"
                "#1caf9a"
                "#636e7b"
              ]
            )
    getOperationsByDate : () ->
      $api.getOperationsByDate
        done : (response) ->
          $translate(['Web', 'Android', 'Others']).then (translate) ->
            plot = jQuery.plot(jQuery("#basicflot"), [
              {
                data: response.finished
                label: translate.Finished
                color: "#1caf9a"
              }
              {
                data: response.canceled
                label: translate.Canceled
                color: "#d9534f"
              }
            ],
              series:
                lines:
                  show: true
                  fill: true
                  lineWidth: 1
                  fillColor:
                    colors: [
                      {
                        opacity: 0.5
                      }
                      {
                        opacity: 0.5
                      }
                    ]

                points:
                  show: true

                shadowSize: 2

              legend:
                position: "nw"

              grid:
                hoverable: true
                clickable: true
                borderColor: "#ddd"
                borderWidth: 1
                labelMargin: 10
                backgroundColor: "#fff"

              yaxis:
                min: 0
                max: response.max
                color: "#eee"

              xaxis:
                mode:  "categories"
                tickLength: 0
            )

    getDrivers : ->
      for key, value of $statistics.drivers
        $statistics.drivers[key] = 0

      for key, value of $drivers.list
        $statistics.drivers[value.status] += 1
        unless value.status is "disconnected"
          $statistics.drivers.total += 1
      $interval ->
        $("#sidebar-drivers-chart").sparkline(
          [
            $map.counters.drivers_online
            $map.counters.drivers_intravel
            $map.counters.drivers_offline
          ]
          type       : "pie"
          height     : "100px"
          sliceColors: ["#1caf9a", "#f0ad4e", "#d9534f", "#636e7b"]
          )
      ,
      60000
      ,
      0

]

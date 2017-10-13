technoridesApp.factory '$statistics', ['$api', '$company', '$translate', ($api, $company, $translate) ->

  $statistics =
    data :
      drivers   :
        total       : 0
        online      : 0
        intravel    : 0
        offline     : 0
        disconnected: 0

      operations:
        total       : 0
        lastTotal   : -1
        history     : [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        byStatus    :
          percents  :
            finished     : 0
            canceled     : 0
            inTransaction: 0
          total     : 0
        byDevice    : {}
        byDate      : {}
        earnings    : 0

      others:
        passengers  : 0

      passengers:
        total       : 0
        lastTotal   : -1
        history     : [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]


    menu:
      drivers:
        draw: ->
          for key, value of $statistics.data.drivers
            $statistics.data.drivers[key] = 0

          for key, value of $company.drivers
            $statistics.data.drivers[value.status] += 1
            unless value.status is "disconnected"
              $statistics.data.drivers.total += 1

          $("#sidebar-drivers-chart").sparkline(
            [
              $statistics.data.drivers.online
              $statistics.data.drivers.intravel
              $statistics.data.drivers.offline
            ]
            type       : "pie"
            height     : "60px"
            sliceColors: ["#1caf9a", "#f0ad4e", "#d9534f", "#636e7b"]
          )


      others:
        passengers:
          getData: ->
            $api.send "getPassengers"


          draw: ->


        getData: ->
          $api.send "getCounters"


        draw   : ->
          # 0 <- 1, 1 <- 2, etc.
          # Last: new total - old total

          # Operations
          for i in [1..($statistics.data.operations.history.length - 1)]
            $statistics.data.operations.history[i - 1] = $statistics.data.operations.history[i]

          # Avoiding first value
          lastValue = 0

          if $statistics.data.operations.lastTotal isnt -1
            lastValue = $statistics.data.operations.total - $statistics.data.operations.lastTotal

          $statistics.data.operations.lastTotal = $statistics.data.operations.total

          $statistics.data.operations.history[$statistics.data.operations.history.length - 1] = lastValue

          $("#sidebar-operations-chart").sparkline($statistics.data.operations.history,
            type    : "bar"
            height  :"60px"
            barColor: "#428bca"
          )

          # Passengers
          for i in [1..($statistics.data.passengers.history.length - 1)]
            $statistics.data.passengers.history[i - 1] = $statistics.data.passengers.history[i]

          # Avoiding first value
          lastValue = 0
          if $statistics.data.passengers.lastTotal isnt -1
            lastValue = $statistics.data.passengers.total - $statistics.data.passengers.lastTotal

          $statistics.data.passengers.lastTotal = $statistics.data.passengers.total

          $statistics.data.passengers.history[$statistics.data.passengers.history.length - 1] = lastValue

          $("#sidebar-passengers-chart").sparkline($statistics.data.passengers.history,
            type    : "bar"
            height  :"60px"
            barColor: "#1caf9a"
          )


    grid:
      others:
        passengers:
          getData: ->
            $api.send "getPassengers"

          draw: ->


      operations:
        byStatus:
          getData: ->
            $api.send "getOperationsByStatus"


          draw: ->


        earnings:
          getData: ->
            $api.send "getOperationsEarnings"


          draw: ->


        byDevice:
          getData: ->
            $api.send "getOperationsByDevice"


          draw: ->
            $translate(['Web', 'Android', 'Others']).then (translate) ->
              m6 = new Morris.Donut(
                element: "donut-chart2"
                data: [
                  {
                    label: translate.Web
                    value: $statistics.data.operations.byDevice.web
                  }
                  {
                    label: translate.Android
                    value: $statistics.data.operations.byDevice.android
                  }
                  {
                    label: translate.Others
                    value: $statistics.data.operations.byDevice.others
                  }
                ]
                colors: [
                  "#428bca"
                  "#1caf9a"
                  "#636e7b"
                ]
              )


        byDate:
          getData: ->
            $api.send "getOperationsByDate"


          draw: ->
            $translate(['Web', 'Android', 'Others']).then (translate) ->
              plot = jQuery.plot(jQuery("#basicflot"), [
                {
                  data: $statistics.data.operations.byDate.finished
                  label: translate.Finished
                  color: "#1caf9a"
                }
                {
                  data: $statistics.data.operations.byDate.canceled
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
                  max: $statistics.data.operations.byDate.max
                  color: "#eee"

                xaxis:
                  mode:  "categories"
                  tickLength: 0
              )


]

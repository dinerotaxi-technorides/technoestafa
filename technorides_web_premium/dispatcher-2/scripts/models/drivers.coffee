technoridesApp.factory '$drivers', ($map,$settings) ->
  $drivers =
    list : []
    driver : {}
    query : ""
    imgUrl: "#{$settings[$settings.environment].api}taxiApi/displayDriverLogoByEmail?email="

    findIndex : (id) ->
      indexFound = -1

      for driver, index in $drivers.list
        if driver.id == id
          indexFound = index
          break

      indexFound
    # FILTER for DIGITAL RADIO

    search : (item) ->
      query = $drivers.query.toString().toLowerCase()
      firstName = item.firstName.toLowerCase()
      lastName = item.lastName.toLowerCase()
      number = item.number.toString()
      if number.indexOf(query) isnt -1 or firstName.indexOf(query) isnt -1 or lastName.indexOf(query) isnt -1
        return true
      else
        return false

    save : (drivers) ->
      $drivers.list = drivers

      for driver in $drivers.list
        $drivers.addOrUpdate driver
        driver.driverImg = "#{$drivers.imgUrl}#{driver.email}&cache=#{(new Date()).getTime()}"

    addOrUpdate: (driver) ->
      # Old driver
      driverIdFound = $drivers.findIndex driver.id

      number        = driver.number
      number        = driver.driverNumber unless number?
      if driverIdFound isnt -1
        driverFound   = $drivers.list[driverIdFound]
        $drivers.list[driverIdFound] = driver
      else
        $drivers.list.push driver

      # Here start to insert marker
      options =
        position     : $map.latLng {lat:driver.lat, lng:driver.lng}
        icon         : "/common/assets/markers/driver_#{driver.status}.png"
        title        : "#{number}"
        labelContent : "#{number}"
        labelClass   : "driverMarkerLabels"
        labelAnchor  : ''#new google.maps.Point(15, -5)
        doCluster    : true
        driver     : driver
      listener =
        event : "click"
        callback : (marker) ->
          $drivers.driver = this.driver
          $(".show-driver").modal("show")
          false

      # Insert or update driver markers
      $map.addOrUpdateMarker "drivers_#{driver.status}", "#{number}", options, [listener]

      # Tooltip
      marker        = $map.getMarker "drivers_#{driver.status}", number
      marker.driver = driver if marker?


      $drivers.list[driverIdFound] = driver

    getDriverInfo: (id) ->
      found = false
      for driver in $drivers.list
        if id is driver.id
          found = driver
      found

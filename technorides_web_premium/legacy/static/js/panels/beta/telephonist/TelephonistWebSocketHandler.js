// Web Socket Handler
function WebSocketHandler() {
  // Connection
  this.connection = null;

  // OnOpen
  this.onOpen = function(data) {
    // Pull Drivers
    this.connection.send(
      {
        action: "company/PullDrivers",
        id    : panel.company.id,
        rtaxi : panel.company.rtaxi
      }
    );

    // Pull Trips
    this.connection.send(
      {
        action: "company/PullTrips",
        id    : panel.company.id,
        rtaxi : panel.company.rtaxi
      }
    );

    countMarkersInterval = setInterval(function() {panel.countMarkers()}, 2500);
    panel.countMarkers();
  }

  // OnClose
  this.onClose = function(data) {
    // Clear operations
    panel.displayClearOperations();
  }

  // OnMessage
  this.onMessage = function(data) {
    // Action?
    switch(data.action) {
      // Pulling Trips
      case "driver/PullInTransaction":
      case "driver/PullingTrips":
        // Add Driver
        driver = panel.company.addDriver(
          new Driver(
            {
              id       : parseInt(data.id),
              number   : parseInt(data.driverNumber),
              status   : data.state,
              latitude : data.lat,
              longitude: data.lng,
              version  : data.version,
              firstName: data.firstName,
              lastName : data.lastName,
              phone    : data.phone,
              email    : data.email,
              company  : data.brandCompany,
              carModel : data.model,
              carPlate : data.plate
            }
          )
        );

        // Marker
        if(panel.shouldShowMarker(driver))
          panel.map.addMarkerDriver(driver);
        else
          panel.map.deleteMarkerDriver(driver)
        break;

        // Counters
        panel.countMarkers();

      // Company Pull Drivers
      case "company/PullDrivers":
        // Saving this
        var that = this;

        // Markers
        $.each(data.drivers, function(index, driverJson) {
          setTimeout(function() {
            // Add Driver
            driver = that.connection.company.addDriver(
              new Driver(
                {
                  id       : parseInt(driverJson.id),
                  number   : parseInt(driverJson.number),
                  status   : driverJson.status,
                  latitude : driverJson.lat,
                  longitude: driverJson.lng,
                  version  : driverJson.version,
                  firstName: driverJson.firstName,
                  lastName : driverJson.lastName,
                  phone    : driverJson.phone,
                  email    : driverJson.email,
                  carBrand : driverJson.brandCompany,
                  carModel : driverJson.model,
                  carPlate : driverJson.plate
                }
              )
            );

            // Driver Panel
            $("#driver_panel_driver_id").append("<option value=" + driver.id + ">" + driver.number + "</option>");
            $("#driver_panel_driver_id").sort_select_box();

            // Marker
            if(panel.shouldShowMarker(driver))
              panel.map.addMarkerDriver(driver);
            else
              panel.map.deleteMarkerDriver(driver);
          }, 100 * index);
        });

        break;

      // Pull Trips
      case "company/PullTrips":
        // Saving this
        var that = this;

        // Operations
        $.each(
          data.operations,
          function(index, operationJson) {
            // Operation
            operation = newOperation(operationJson);

            // Add Operation
            panel.company.addOperation(operation);

            // Marker
            if(panel.showOperations)
              panel.map.addMarkerOperation(operation);

            // Counters
            panel.countMarkers();
          }
        );

        // Counters
        panel.countMarkers();

        // Update Counters
        panel.displayUpdateCounters();
        break;

      // New Trip
      case "web/newTrip":
      case "newTrip":
        // Operation
        operation = newOperation(data.operation);

        // Add Operation
        panel.company.addOperation(operation);

        // Marker
        if(panel.showOperations)
          panel.map.addMarkerOperation(operation);

        // Counters
        panel.countMarkers();

        break;

      // Accept Trip
      case "driver/AcceptTrip":
        // Invalid?
        switch(data.message) {
          case 404:
            $("#invalid_driver_error_dialog").dialog("open");
            break;
          case 405:
            $("#offline_driver_error_dialog").dialog("open");
            break;
        }
        break;

      // Operation messages
      default:
        // Operation?
        if(data.opid) {
          // Operation
          operation = panel.company.operations[data.opid];

          // Update
          operation.update(data);
        }
        break;
    }
  }
}

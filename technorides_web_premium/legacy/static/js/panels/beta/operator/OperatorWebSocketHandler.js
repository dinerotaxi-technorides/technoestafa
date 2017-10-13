// Web Socket Handler
function WebSocketHandler() {
  // Connection
  this.connection = null;
  var countMarkersInterval    = null;

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

    countMarkersInterval = setInterval(function() {panel.countMarkers();}, 2500);
    panel.countMarkers();
  };

  // OnClose
  this.onClose = function(data) {
    // Clear operations
    panel.displayClearOperations();
  };

  // OnMessage
  this.onMessage = function(data) {
    // Action?
    switch(data.action) {
      // Finding Driver
      case "company/FindingDriver":
        // Updating Operation
        $("#operation_" + data.opid + " .operation_driver").html(I18n.panels.operator.finding_driver);
        var operation = panel.company.operations[data.opid];
        if(operation !== undefined) {
          operation.FindingDriver = true;
        }

        break;

      // Driver not found
      case "company/DriverNotFound":
        // Updating Operation
        if((panel.company.operations[data.opid] !== undefined) && (panel.company.operations[data.opid].driverId === null)) {
          $("#operation_" + data.opid + " .operation_driver").html(I18n.panels.operator.driver_not_found);
          panel.company.operations[data.opid].FindingDriver = false;
        }

        break;

      // Another Driver assigned
      case "company/AnotherDriverAssigned":
        // Dialog
        $("#another_driver_assigned_operation_operation_id").html(data.opid);
        $("#another_driver_assigned_operation_dialog").dialog("open");

        break;

      // Another Driver assigned
      case "driver/AnotherDriverAssigned":

        break;

      // Pulling Trips
      case "driver/PullInTransaction":
      case "driver/PullingTrips":
        // Old Driver
        var oldDriver = jQuery.extend(true, {}, panel.company.drivers[data.id]);

        // Add Driver
        var driver = panel.company.addDriver(
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
              carBrand : data.brandCompany,
              carModel : data.model,
              carPlate : data.plate
            }
          )
        );

        // Marker
        if(panel.shouldShowMarker(driver))
          panel.map.addMarkerDriver(driver, oldDriver);

        break;

      // Company Pull Drivers
      case "company/PullDrivers":
        // Markers
        $.each(data.drivers, function(index, driverJson) {
          setTimeout(function() {
            // Add Driver
            var driver = panel.company.addDriver(
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

            // Old Driver
            var oldDriver = jQuery.extend(true, {}, panel.company.drivers[data.id]);
            if(panel.shouldShowMarker(driver))
              panel.map.addMarkerDriver(driver, oldDriver);

            // Driver Panel
            $("#driver_panel_driver_id").append("<option value=" + driver.id + ">" + driver.number + "</option>");
            $("#driver_panel_driver_id").sort_select_box();
          }, 100 * index);
        });

        break;

      // Pull Trips
      case "company/PullTrips":
        // Operations
        $.each(
          data.operations,
          function(index, operationJson) {
            if(!(operationJson.status === undefined) && !(operationJson.status == "CANCELED_TAXI")) {
              // Operation
              operation = newOperation(operationJson);

              // Add Operation
              panel.company.addOperation(operation);

              // Marker
              if(panel.showOperations)
                panel.map.addMarkerOperation(operation);
            }
          }
        );

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

      // Operation messages
      default:
        // Operation?
        if(data.opid) {
          // Operation
          operation = panel.company.operations[data.opid];

          // Update
          if(operation !== undefined)
            operation.update(data);
        }
        break;
    }
  };
}

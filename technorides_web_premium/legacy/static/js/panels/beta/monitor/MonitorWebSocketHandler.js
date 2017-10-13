// Web Socket Handler
function WebSocketHandler() {
  // Connection
  this.connection = null;

  // OnOpen
  this.onOpen = function(data) {
    // Pull Drivers
    this.connection.send(
      {
        action: "company/PullAllDrivers",
        id    : panel.company.id,
        rtaxi : panel.company.rtaxi
      }
    );
  }

  // OnClose
  this.onClose = function(data) {}

  // OnMessage
  this.onMessage = function(data) {
    // Action?
    switch(data.action) {
      // Pulling Trips
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
              carBrand : data.brandCompany,
              carModel : data.model,
              carPlate : data.plate
            }
          )
        );

        // Marker
        panel.map.addMarkerDriver(driver);
        break;

      // Company Pull Drivers
      case "company/PullDrivers":
        // Saving this
        var that = this;

        // Markers
        $.each(
          data.drivers,
          function(index, driverJson) {
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

            // Marker
            that.connection.map.addMarkerDriver(driver);
          }
        );

        break;
    }
  }
}

function Panel(args) {
  this.company                 = args.company;
  this.map                     = args.map;
  this.webSocketConnection     = null;
  this.api                     = null;
  this.url                     = window.location.protocol + "//" + window.location.host;
  this.panel                   = false;

  this.showOnlineDrivers       = true;
  this.showOfflineDrivers      = true;
  this.showIntravelDrivers     = true;
  this.showDisconnectedDrivers = false;
  this.showOperations          = true;
  this.showParkings            = true;

  this.debug                   = false;

  // Add Marker
  this.addMarker = function() {
    // Home
    if(this.company.latitude != 0 && this.company.longitude != 0) {
      if(this.map.markers["home"] == undefined) {
        this.map.panTo(this.company.latitude, this.company.longitude);
      }

      this.map.addMarkerCompany(company);
    }
  }

  // Clear Operations
  this.displayClearOperations = function() {
    // Operations
    $("#grid table tbody tr").remove();

    // Counter
    this.displayUpdateCounters();
  }

  // Update Counters
  this.displayUpdateCounters = function() {
    operationsContainer = $("#operations_container");
    // Pending
    $("#pending_operations_counters").text("(" + operationsContainer.find(".pending_operation").length + ")");

    // Intransaction
    $("#intransaction_operations_counters").text("(" + operationsContainer.find(".intransaction_operation").length + ")");

    // Completed
    $("#completed_operations_counters").text("(" + operationsContainer.find(".completed_operation").length + ")");

    // Scheduled
    $("#scheduled_operations_counters").text("(" + operationsContainer.find(".scheduled_operation").length + ")");
  }

  this.shouldShowMarker = function(driver) {
    switch(driver.status) {
      case "ONLINE":
        return this.showOnlineDrivers;
        break;

      case "OFFLINE":
        return this.showOfflineDrivers;
        break;

      case "DISCONNECTED":
        return this.showDisconnectedDrivers;
        break;

      case "INTRAVEL":
      default:
        return this.showIntravelDrivers;
        break;
    }
  }

  this.showOrHideAllMarkersBasedOnState = function() {
    var that = this;

    $.each(that.company.operations, function(index, value) {
      if(that.showOperations) {
        that.map.addMarkerOperation(value);
      } else {
        that.map.deleteMarkerOperation(value);
      }
    });

    $.each(that.company.parkings, function(index, value) {
      if(that.showParkings) {
        that.map.addMarkerParking(value);
      } else {
        that.map.deleteMarkerParking(value);
      }
    });

    $.each(that.company.drivers, function(index, value) {
      if(that.shouldShowMarker(value)) {
        var oldDriver = jQuery.extend(true, {}, panel.company.drivers[value.id]);
        oldDriver.status = "FAKE";
        that.map.addMarkerDriver(value, oldDriver);
      } else {
        that.map.deleteMarkerDriver(value);
      }
    });
  };

  this.countMarkers = function() {
    console.log("Counting drivers...");

    that = this;

    drivers_online_counter       = 0;
    drivers_intravel_counter     = 0;
    drivers_disconnected_counter = 0;
    drivers_offline_counter      = 0;

    $.each(that.company.drivers, function(index, value) {
      switch(value.status) {
        case "ONLINE":
          drivers_online_counter       += 1;
          break;

        case "OFFLINE":
          drivers_offline_counter      += 1;
          break;

        case "DISCONNECTED":
          drivers_disconnected_counter += 1;
          break;

        case "INTRAVEL":
        default:
          drivers_intravel_counter     += 1;
          break;
      }
    });

    operations_counter = 0;
    $.each(that.company.operations, function(index, value) {
      if(!value.isCompleted)
        operations_counter += 1;
    });

    this.displayCountMarkers(drivers_online_counter, drivers_intravel_counter, drivers_disconnected_counter, drivers_offline_counter, operations_counter, Object.keys(panel.company.parkings).length);
  }

  this.displayCountMarkers = function(online_drivers_counter, intravel_drivers_counter, disconnected_drivers_counter, offline_drivers_counter, operations_counter, parkings_counter) {
    $("#online_drivers_counter").html(online_drivers_counter);
    $("#intravel_drivers_counter").html(intravel_drivers_counter);
    $("#disconnected_drivers_counter").html(disconnected_drivers_counter);
    $("#offline_drivers_counter").html(offline_drivers_counter);
    $("#operations_counter").html(operations_counter);
    $("#parkings_counter").html(parkings_counter);
  }
}

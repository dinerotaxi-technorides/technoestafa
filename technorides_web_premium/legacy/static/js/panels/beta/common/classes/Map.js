function Map(args) {
  this.zoom       = args.zoom;
  this.hideLabels = args.hideLabels;
  this.markers    = {};
  this.circles    = {};
  this.rectangles = {};

  if(args.options !== undefined) {
    this.options    = args.options;
  } else {
    // Options
    this.options      = {
      zoom             : this.zoom,
      center           : new google.maps.LatLng(args.latitude, args.longitude),
      mapTypeId        : google.maps.MapTypeId.ROADMAP,
      streetViewControl: false,
      mapTypeControl   : true,
      zoomControl      : true,
      panControl       : false,
      minZoom          : 1,
      maxZoom          : 20
    };
  }

  // Map
  this.map        = new google.maps.Map(
    document.getElementById(args.id), this.options
  );

  this.clusters = {};

  this.addMarkerDriverToCluster = function(driver) {
    this.addMarkerToCluster(driver.getMarkerStatus(), driver.getMarker());
  };

  this.deleteMarkerDriverFromCluster = function(driver) {
    this.deleteMarkerFromCluster(driver.getMarkerStatus(), driver.getMarker());
  };

  this.deleteMarkerFromCluster = function(clusterName, marker) {
    if(marker !== undefined && this.clusters[clusterName] !== undefined) {
      if(this.clusters[clusterName].markers !== undefined && this.clusters[clusterName].markers[marker.id] !== undefined) {
        delete this.clusters[clusterName].markers[marker.id];
      }
    }
    try {
      this.clusters[clusterName].removeMarker(marker.marker);
    } catch(error) {}
  };

  // Add Company Marker
  this.addMarkerCompany = function(company) {
    var icon = panel.url + "/static/images/panels/operator/home.png"; // Marker
    var markerName = (this.markers.home === undefined ? "home" : "home_" + company.id);
    this.markers[markerName] = new Marker(
      {
        map           : this.map,
        id            : markerName,
        latitude      : company.latitude,
        longitude     : company.longitude,
        icon          : icon,
        label         : company.name,
        infoWindowText: "",
        draggable     : false
      }
    );

    this.markers[markerName].show(); // Show
  };

  // Add Marker
  this.addMarkerDriver = function(driver, oldDriver) {
    var driverStatus = driver.getMarkerStatus().toLowerCase();

    var icon = panel.url + "/static/images/panels/operator/status/driver_" + driverStatus + ".png";

    // Existent?
    if(oldDriver !== undefined) {
      // Delete? (new status / cluster changing)
      if(oldDriver.status != driver.status) {
        this.deleteMarkerDriver(driver);
      } else {
        var oldDriverMarker = oldDriver.getMarker();
        if(oldDriverMarker !== undefined) {
          oldDriverMarker.update(driver.latitude, driver.longitude, icon);
          return true;
        }
      }
    }

    // Add New Marker
    var markerTooltip = "";
    var markerLabel = "";
    if(!this.hideLabels) {
      markerTooltip = "<table class='driver_detail'>";
        markerTooltip += "<tr><td colspan='2' class='driver_detail_title'>" + I18n.panels.operator.driver + " " + driver.number + "</td></tr>";
        markerTooltip += "<tr>";
          markerTooltip += "<td valign='top'><img src='" + panel.api.DRIVER_IMAGE_URL + "?email=" + driver.email + "' onerror=\"this.src='/static/images/panels/operator/profile_error.png';\"></td>";
          markerTooltip += "<td valign='top'><table>";
            if(driver.fullName() != " ")
              markerTooltip += "<tr><td class='driver_detail_label'>" + I18n.panels.operator.driver_name + "</td><td>" + driver.fullName() + "</td></tr>";

            if(driver.phone !== "")
              markerTooltip += "<tr><td class='driver_detail_label'>" + I18n.panels.operator.driver_phone + "</td><td>" + driver.phone + "</td></tr>";

            if(driver.email !== "")
              markerTooltip += "<tr><td class='driver_detail_label'>" + I18n.panels.operator.driver_email + "</td><td>" + driver.email + "</td></tr>";

            if(driver.car() !== " ")
              markerTooltip += "<tr><td class='driver_detail_label'>" + I18n.panels.operator.driver_car + "</td><td>" + driver.car() + "</td></tr>";

            if(driver.carPlate !== "")
              markerTooltip += "<tr><td class='driver_detail_label'>" + I18n.panels.operator.driver_car_plate + "</td><td>" + driver.carPlate + "</td></tr>";

            if(driver.status !== "")
              markerTooltip += "<tr><td class='driver_detail_technical_information' colspan='2'>ID: " + driver.id + " - v" + driver.version + "</td></tr>";
          markerTooltip += "</table></td>";
        markerTooltip += "</tr>";
      markerTooltip += "</table>";
      markerLabel = driver.number;
    } else {
      markerTooltip = "";
      markerLabel = "";
    }

    this.markers["driver_" + driver.number] = new Marker(
      {
        map           : this.map,
        id            : "driver_" + driver.number,
        latitude      : driver.latitude,
        longitude     : driver.longitude,
        icon          : icon,
        label         : markerLabel,
        infoWindowText: markerTooltip,
        draggable     : false
      }
    );

    // Show
    var marker = this.markers["driver_" + driver.number];
    marker.show();

    // Clustered
    panel.map.addMarkerDriverToCluster(driver);
  };

  this.addMarkerToCluster = function(clusterName, marker, styles) {

    if(styles === undefined)
      styles = {
        textColor : "black",
        width     : 47,
        height    : 33,
      };
    var markerIcon = marker.marker.icon.split(".png");
    styles.url = markerIcon[0] + "_cluster.png";

    if(typeof MarkerClusterer !== "undefined") {
      // New cluster?
      if(this.clusters[clusterName] === undefined) {
        this.clusters[clusterName] = new MarkerClusterer(this.map, [], {
          gridSize: 40,
          maxZoom : this.options.maxZoom - 2,
          styles  : [styles]
        });

        // Markers
        this.clusters[clusterName].markers = {};
      }

      // New in cluster?
      if(this.clusters[clusterName].markers[marker.id] === undefined) {
        this.clusters[clusterName].markers[marker.id] = marker;

        // Cluster
        this.clusters[clusterName].addMarker(marker.marker);
      }
    }
  };

  // Add Parking Marker
  this.addMarkerParking = function(parking) {
    var icon       = panel.url + "/static/images/panels/operator/parking.png"; // Marker
    var markerName = "parking_" + parking.id;

    if(this.markers[markerName] !== undefined) {
      this.deleteMarkerParking(parking);
    }

    this.markers[markerName] = new Marker(
      {
        map           : this.map,
        id            : markerName,
        latitude      : parking.latitude,
        longitude     : parking.longitude,
        icon          : icon,
        label         : parking.name,
        infoWindowText: "",
        draggable     : false
      }
    );

    this.markers[markerName].show(); // Show

    this.addMarkerToCluster("PARKING", this.markers[markerName]);
  };

  this.deleteMarkerParkingFromCluster = function(parking) {
    if(typeof MarkerClusterer !== "undefined") {
      if(this.clusters.PARKING !== undefined && parking.getMarker() !== undefined) {
        this.deleteMarkerFromCluster("PARKING", parking);
      }
    }
  };

  // Add Draggable Parking Marker
  this.addDraggableMarkerParking = function(parking, endDragAction, startDragAction, clickAction) {
    var icon       = panel.url + "/static/images/panels/operator/parking.png"; // Marker
    var markerName = "parking_" + parking.id;
    this.addDraggableMarker(markerName, parking.latitude, parking.longitude, icon, parking.name, "", endDragAction, startDragAction, clickAction);
  };

  // Add Driver Circle Parking
  this.addCircleDriverParking = function(parking) {
    var circleName = "driver_parking_" + parking.id;

    if(this.circles[circleName] !== undefined) {
      this.circles[circleName].circle.setMap(null);
    }

    this.circles[circleName] = new Circle(
      {
        map           : this.map,
        id            : circleName,
        latitude      : parking.latitude,
        longitude     : parking.longitude,
        radius        : panel.company.configuration.search_driver_distance,
        color         : "#56a985",
        background    : "#56a985"
      }
    );

    this.circles[circleName].show(); // Show
  };

  // Add Passenger Circle Parking
  this.addCirclePassengerParking = function(parking) {
    var circleName = "passenger_parking_" + parking.id;

    if(this.circles[circleName] !== undefined) {
      this.circles[circleName].circle.setMap(null);
    }

    this.circles[circleName] = new Circle(
      {
        map           : this.map,
        id            : circleName,
        latitude      : parking.latitude,
        longitude     : parking.longitude,
        radius        : panel.company.configuration.search_passenger_distance,
        color         : "#0054a6",
        background    : "#0054a6"
      }
    );

    this.circles[circleName].show(); // Show
  };

  // Refresh circles and markers
  this.refreshCirclesAndMarkerParkings = function(endDragAction, startDragAction, clickAction) {
    $.each(this.circles, function(index, value) {
      value.circle.setMap(null);
      delete panel.map.circles[value.id];
    });

    $.each(panel.company.parkings, function(index, value) {
      panel.map.addDraggableMarkerParking(value, endDragAction, startDragAction, clickAction);
      panel.map.addCircleDriverParking(value);
      panel.map.addCirclePassengerParking(value);
      panel.addMarker();
    });
  };

  // Refresh rectangles
  this.refreshRectanglesZones = function(currentId) {
    $.each(this.rectangles, function(index, value) {
      if(value !== undefined && value.id != "zone_" + currentId) {
        value.rectangle.setMap(null);
        delete panel.map.rectangles[value.id];
      }
    });

    $.each(panel.company.zones, function(index, value) {
      if(value !== undefined && value.id != currentId) {
        panel.map.addRectangleZone(value, {
          click         : function(data) {
            rectangleLink = $("#" + data.rectangleId + "_link");
            // FIXME: Find a way to differenciate automatic clicks from manual clicks
            rectangleLink.data("automatic_click", true);
            rectangleLink.click();
            rectangleLink.data("automatic_click", false);
          },
          dragstart     : function(data) {
          },
          dragend       : function(data) {
          },
          bounds_changed: function(data) {
            rectangleLink = $("#" + data.rectangleId + "_link");
            // FIXME: Find a way to differenciate automatic clicks from manual clicks
            rectangleLink.data("automatic_click", true);
            rectangleLink.click();
            rectangleLink.data("automatic_click", false);
            latLng1 = data.getBounds().getSouthWest();
            latLng2 = data.getBounds().getNorthEast();
            $("#zone_latitude1").val(latLng1.lat());
            $("#zone_longitude1").val(latLng1.lng());
            $("#zone_latitude2").val(latLng2.lat());
            $("#zone_longitude2").val(latLng2.lng());
            rectangleValidator = new Rectangle({id: data.rectangleId, latitude1: latLng1.lat(), longitude1: latLng1.lng(), latitude2: latLng2.lat(), longitude2: latLng2.lng()});
            $("#zone_form input[type=submit]").prop("disabled", !rectangleValidator.hasValidBounds());

          }
        });
      }
    });
    panel.addMarker();
  };

  // Add Rectangle Zone
  this.addRectangleZone = function(zone, actions) {
    var rectangleName = "zone_" + zone.id;

    if(this.rectangles[rectangleName] !== undefined) {
      this.rectangles[rectangleName].rectange.setMap(null);
    }

    this.addRectangle(rectangleName, zone.latitude1, zone.longitude1, zone.latitude2, zone.longitude2, "#0054a6", "#0054a6", actions);
  };

  // Add Rectangle
  this.addRectangle = function(newId, newLatitude1, newLongitude1, newLatitude2, newLongitude2, newColor, newBackground, actions) {
    this.rectangles[newId] = new Rectangle(
      {
        map           : this.map,
        id            : newId,
        latitude1     : newLatitude1,
        longitude1    : newLongitude1,
        latitude2     : newLatitude2,
        longitude2    : newLongitude2,
        color         : newColor,
        background    : newBackground,
        draggable     : true,
        editable      : true
      }
    );

    this.rectangles[newId].show(); // Show

    var rectangle = this.rectangles[newId];

    google.maps.event.addListener(this.rectangles[newId].rectangle, "bounds_changed", function() {
      actions.bounds_changed(this);
    });

    google.maps.event.addListener(this.rectangles[newId].rectangle, "click", function() {
      actions.click(this);
    });

    google.maps.event.addListener(this.rectangles[newId].rectangle, "dragend", function() {
      actions.dragend(this);
    });

    google.maps.event.addListener(this.rectangles[newId].rectangle, "dragstart", function() {
      actions.dragstart(this);
    });
  };

  // Add Operation
  this.addMarkerOperation = function(operation) {
    // Status
    var operationStatus = operation.status.toLowerCase();
    if(operationStatus == "assignedtaxi" || operationStatus == "assignedradiotaxi") {
      operationStatus = "assigned";
    }
    else {
      if(operationStatus != "pending") {
        operationStatus = "intransaction";
      }
    }
    var icon = panel.url + "/static/images/panels/operator/status/operation_" + operationStatus + ".png";

    // New Marker?
    if(this.markers["operation_" + operation.id] === undefined) {
      // Add New Marker
      this.markers["operation_" + operation.id] = new Marker(
        {
          map           : this.map,
          id            : "operation_" + operation.id,
          latitude      : operation.latitude,
          longitude     : operation.longitude,
          icon          : icon,
          label         : operation.id,
          infoWindowText: I18n.panels.operator.operation_id + ": " + operation.id.toString(),
          draggable     : false
        }
      );

      // Show
      this.markers["operation_" + operation.id].show();
    }
    else {
      // Update data
      this.markers["operation_" + operation.id].update(operation.latitude, operation.longitude, icon);
    }
  };

  // Add Draggable Marker
  this.addDraggableMarker = function(newId, newLatitude, newLongitude, newIcon, newLabel, newInfoWindowText, endDragAction, startDragAction, clickAction) {
    if(this.markers[newId] === undefined) {
      this.markers[newId] = new Marker(
        {
          map           : this.map,
          id            : newId,
          latitude      : newLatitude,
          longitude     : newLongitude,
          icon          : newIcon,
          label         : newLabel,
          infoWindowText: newInfoWindowText,
          draggable     : true
        }
      );
      this.markers[newId].show();
    }
    else {
      this.markers[newId].update(newLatitude, newLongitude, newIcon);
    }
    if(endDragAction !== undefined)
      google.maps.event.addListener(this.markers[newId].marker, "dragend",
        function() {
          endDragAction(this.getPosition(), this);
        }
      );
    if(startDragAction !== undefined)
      google.maps.event.addListener(this.markers[newId].marker, "dragstart",
        function() {
          startDragAction(this.getPosition(), this);
        }
      );
    if(clickAction !== undefined)
      google.maps.event.addListener(this.markers[newId].marker, "click",
        function() {
          clickAction(this.getPosition(), this);
        }
      );
  };

  // Pan
  this.panTo = function(latitude, longitude) {
    // LatLng
    var latLng = new google.maps.LatLng(latitude, longitude);
    this.map.panTo(latLng);
  };

  // Set Zoom
  this.setZoom = function(zoom) {
    this.map.setZoom(zoom);
  };

  // Show all markers
  this.showAllMarkers = function() {
    var bounds = new google.maps.LatLngBounds();
    $.each(panel.map.markers, function(index, value) {
      if(value !== undefined && value.marker.map !== null)
        bounds.extend(value.marker.getPosition());
    });

    this.map.fitBounds(bounds);
  };

  // Delete Marker Driver
  this.deleteMarkerDriver = function(driver) {
    var markerId = "driver_" + driver.number;

    this.deleteMarkerDriverFromCluster(driver);

    this.deleteMarker(markerId);
  };

  // Delete Marker Operation
  this.deleteMarkerOperation = function(operation) {
    this.deleteMarker("operation_" + operation.id);
  };

  // Delete Marker Parking
  this.deleteMarkerParking = function(parking) {
    var markerId = "parking_" + parking.id;
    this.deleteMarkerParkingFromCluster(parking);
    this.deleteMarker(markerId);
  };

  // Delete Marker
  this.deleteMarker = function(markerId) {
    try {
      // Removing from another clusters
      $.each(this.clusters, function(index, value) {
        panel.map.deleteMarkerFromCluster(index, this.markers[markerId]);
      });

      this.markers[markerId].marker.setMap(null);
    } catch(error) {}

    delete this.markers[markerId];
  };
}

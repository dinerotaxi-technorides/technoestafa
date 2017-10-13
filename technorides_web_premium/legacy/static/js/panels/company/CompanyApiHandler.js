function CompanyApiHandler() {
  // Configuration
  this.onConfigurationGot = function(success, data) {
    if(success) {
      $("#configuration_id").val(data.id);
      $("#configuration_parking").prop("checked", data.parking);
      $("#configuration_parking").switchButton({checked: data.parking});

      $("#configuration_movement").val(data.intervalPoolingTrip);
      $(".slider[rel=#configuration_movement]").slider("value", data.intervalPoolingTrip || 0);

      percentageSearchRatio = parseFloat(data.percentageSearchRatio) * 100;
      if(isNaN(percentageSearchRatio))
        percentageSearchRatio = 0;
      $("#configuration_percentage_search_ratio").val(percentageSearchRatio);
      $(".slider[rel=#configuration_percentage_search_ratio]").slider("value", percentageSearchRatio);

      $("#configuration_schedule").val(data.timeDelayTrip);
      $(".slider[rel=#configuration_schedule]").slider("value", data.timeDelayTrip || 0);

      $("#configuration_distance").val(data.distanceSearchTrip);
      $(".slider[rel=#configuration_distance]").slider("value", data.distanceSearchTrip || 0);

      $("#configuration_drivers").val(data.driverSearchTrip);
      $(".slider[rel=#configuration_drivers]").slider("value", data.driverSearchTrip || 0);

      $("#configuration_enable_mobile_payment").prop("checked", data.hasMobilePayment || 0);
      $("#configuration_enable_mobile_payment").switchButton({checked: data.hasMobilePayment});

      $("#configuration_enable_driver_payment").prop("checked", data.hasDriverPayment || 0);
      $("#configuration_enable_driver_payment").switchButton({checked: data.hasDriverPayment});
      $("#configuration_driver_payment").val(data.driverPayment);
      $("#configuration_driver_payment_type").val(data.driverTypePayment);

      $("#configuration_driver_payment_amount").val(data.driverAmountPayment);
      $(".slider[rel=#configuration_driver_payment_amount]").slider("value", data.driverAmountPayment || 0);

      $("#parking_distance_driver").val(data.parkingDistanceDriver);
      $(".slider[rel=#parking_distance_driver]").slider("value", data.parkingDistanceDriver || 0);
      if(panel.company.configuration != undefined)
        panel.company.configuration["search_driver_distance"] = data.parkingDistanceDriver;

      $("#parking_distance_trip").val(data.parkingDistanceTrip);
      $(".slider[rel=#parking_distance_trip]").slider("value", data.parkingDistanceTrip || 0);
      if(panel.company.configuration != undefined)
        panel.company.configuration["search_passenger_distance"] = data.parkingDistanceTrip;

      if(!data.hasDriverPayment) {
        $(".drivers_payment_configuration").hide("fast");
      } else {
        $(".drivers_payment_configuration").show("fast");
      }

      if(!data.parking) {
        $(".parkings_configuration").hide("fast");
      } else {
        $(".parkings_configuration").show("fast");
      }

      $("#configuration_zones").prop("checked", data.hasZoneActive);
      $("#configuration_zones").switchButton({checked: data.hasZoneActive});

      if(!data.hasZoneActive) {
        $(".zones_configuration").hide("fast");
      } else {
        $(".zones_configuration").show("fast");
      }

      $("#configuration_zones_required").prop("checked", data.hasRequiredZone);
      $("#configuration_zones_required").switchButton({checked: data.hasRequiredZone});

      if(panel.map != null && $("#configuration_parking").length > 0) {
        panel.api.getParkings();
      }

      if(panel.map != null && $("#configuration_zones").length > 0) {
        panel.api.getZones();
      }

      $("#configuration_pricing_min_price").val(data.costRutePerKmMin);
      $("#configuration_pricing_km_price").val(data.costRutePerKm);

      $("#configuration_webpage_title").val(data.pageTitle);
      $("#configuration_webpage_url").val(data.pageUrl);
      if(typeof tinyMCE !== "undefined") {
        companyTitleTinyMCE = tinyMCE.get("configuration_webpage_company_title");
        if(companyTitleTinyMCE != null)
          companyTitleTinyMCE.setContent(data.pageCompanyTitle);
        companyDescriptionTinyMCE = tinyMCE.get("configuration_webpage_company_description");

        if(companyDescriptionTinyMCE != null)
          companyDescriptionTinyMCE.setContent(data.pageCompanyDescription);
      }
      $("#configuration_webpage_company_street").val(data.pageCompanyStreet);
      $("#configuration_webpage_company_zipcode").val(data.pageCompanyZipCode);
      $("#configuration_webpage_company_state").val(data.pageCompanyState);
      $("#configuration_webpage_company_linkedin").val(data.pageCompanyLinkedin);
      $("#configuration_webpage_company_facebook").val(data.pageCompanyFacebook);
      $("#configuration_webpage_company_twitter").val(data.pageCompanyTwitter);

      $("#configuration_webpage_company_phone").val(data.phone);
      $("#configuration_webpage_company_phone1").val(data.phone1);
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Configuration
  this.onConfigurationSet = function(success, data) {
    if(success) {
      $("#form_save_dialog").dialog("open");
      panel.api.getConfiguration();
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Parkings
  this.onParkingsGot = function(success, data) {
    if(success) {
      parkingsTable = $("#parkings table tbody");
      parkingsTable.empty();

      $.each(panel.map.markers, function(index, value) {
        value.marker.setMap(null);
      });
      $.each(panel.map.circles, function(index, value) {
        value.circle.setMap(null);
      });
      panel.map.markers      = {};
      panel.company.parkings = {};
      panel.map.circles  = {};

      $.each(data.rows, function(index, value) {
        panel.company.parkings[value.id] = new Parking({id: value.id, name: value.name, latitude: value.lat, longitude: value.lng});
        editLink                         = "<a href='' class='edit_parking' id='parking_" + value.id + "_link' rel='" + JSON.stringify(value) + "'>" + value.name + "</a>";
        destroyLink                      = "<a href='' class='destroy_parking btn btn-danger' rel='" + JSON.stringify(value) + "'>" + window.I18n.panels.company.destroy_parking + "</a>";
        parkingsTable.append("<tr><td>" + editLink + "</td><td>" + destroyLink + "</td></tr>");
      });

      panel.map.refreshCirclesAndMarkerParkings(
        function(data) {
          $("#parking_latitude").val(data.lat());
          $("#parking_longitude").val(data.lng());
        }, function(data, marker) {
          circleLink = $("#" + marker.markerId + "_link");
          // FIXME: Find a way to differenciate automatic clicks from manual clicks
          circleLink.data("automatic_click", true);
          circleLink.click();
          circleLink.data("automatic_click", false);
        }, function(data, marker) {
          circleLink = $("#" + marker.markerId + "_link");
          // FIXME: Find a way to differenciate automatic clicks from manual clicks
          circleLink.data("automatic_click", true);
          circleLink.click();
          circleLink.data("automatic_click", false);
        }
      );
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Add Parking
  this.onParkingAdded = function(success, data) {
    if(success) {
      panel.api.getParkings();
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Update Parking
  this.onParkingUpdated = function(success, data) {
    if(success) {
      panel.api.getParkings();
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }
 
  // Destroy Parking
  this.onParkingDestroyed = function(success, data) {
    if(success) {
      panel.api.getParkings();
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Zones
  this.onZonesGot = function(success, data) {
    if(success) {
      zonesTable = $("#zones table tbody");
      zonesTable.empty();

      $.each(panel.map.rectangles, function(index, value) {
        value.rectangle.setMap(null);
      });
      panel.company.zones  = {};
      panel.map.rectangles = {};

      $.each(data, function(index, value) {
        var coordinates    = value.coordinates.split("|");
        var x1y1 = [0,0];
        var x2y2 = [0,0];

        if(coordinates.length >= 4) {
          x1y1 = coordinates[0].split(",");
          x2y2 = coordinates[2].split(",");
        }
        zoneAttributes = {id: value.id, name: value.name, latitude1: parseFloat(x1y1[0]), longitude1: parseFloat(x1y1[1]), latitude2: parseFloat(x2y2[0]), longitude2: parseFloat(x2y2[1])};
        panel.company.zones[value.id] = new Zone(zoneAttributes);
        editLink = "<a href='' class='edit_zone' id='zone_" + value.id + "_link' rel='" + JSON.stringify(zoneAttributes) + "'>" + value.name + "</a>";
        destroyLink = "<a href='' class='destroy_zone btn btn-danger' rel='" + JSON.stringify(zoneAttributes) + "'>" + window.I18n.panels.company.destroy_parking + "</a>";
        zonesTable.append("<tr><td>" + editLink + "</td><td>" + destroyLink + "</td></tr>");
      });

      panel.map.refreshRectanglesZones();
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }
 
  // Destroy Zone
  this.onZoneDestroyed = function(success, data) {
    if(success) {
      panel.api.getZones();
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Add Zone
  this.onZoneAdded = function(success, data) {
    if(success) {
      panel.api.getZones();
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Update Zone
  this.onZoneUpdated = function(success, data) {
    if(success) {
      panel.api.getZones();
    } else {
      $("#api_connection_error_dialog").dialog("open");
    }
  }
}

CompanyApiHandler.inherits(ApiHandler);

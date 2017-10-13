// Api Handler
function ApiHandler() {
  // Api
  this.api = null;

  // Get Company Information
  this.onCompanyInformationGot = function(success, data) {}

  // Geocode
  this.onGeocode = function(success, data, action) {
    if(success) {
      position = data[0].geometry.location;
      action(position, data);
    }
  }

  // Get History
  this.onHistoryGot = function(success, data) {
    if(success) {
      // Clear Favorites
      $("#favorites_items").html("");
      // Items
      $.each(
        data.result,
        function(index, item) {
          $("#favorites_items").append("<li class='favorites_link' rel='" + JSON.stringify(item) + "'>" + item.street + " " + item.street_number + "</li>");
        }
      );
      $(".toggle[rel='.favorites']:contains(+)").click();
    } else {
      if (data.status == 411) {
        location.reload();
      }
      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Create Operation
  this.onOperationCreated = function(success, data) {
    if(success) {
      // Clear
      clearForm();
    } else {
      $("#api_connection_error_dialog").dialog("open");
      $("#new_operation_dialog").dialog("open");
    }
  }

  // Cancel Scheduled Operation
  this.onScheduledOperationCanceled = function(success, data) {
    if(success) {
      panel.api.getScheduledOperations();
    } else {
      if(data.status == 411) {
        location.reload();
      }

      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Assign Scheduled Operation
  this.onScheduledOperationAssigned = function(success, data) {
    if(success) {
      panel.api.getScheduledOperations();
    } else {
      if(data.status == 411) {
        location.reload();
      }

      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Create Scheduled Operation
  this.onScheduledOperationCreated = function(success, data) {
    if(success) {
      // Clear
      clearForm();
    } else {
      // Reload
      if (data.status == 411) {
        location.reload();
      }

      $("#api_connection_error_dialog").dialog("open");
      $("#new_operation_dialog").dialog("open");
    }
  }

  // Get Scheduled Operations
  this.onScheduledOperationsGot = function(success, data) {
    if(success) {
      // Clear Favorites
      $("#scheduled_operations tbody").html("");
      // Items
      if(data.result != undefined) {
        
        $.each(
          data.result,
          function(index, item) {
            item["status"] = "SCHEDULED";
            item["created_at"] = item.date;

            newOperation(item);
          }
        );
      }

      // Counters
      panel.displayUpdateCounters();
    } else {
      if(data.status == 411) {
        location.reload();
      }

      // $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Get Parkings
  this.onParkingsGot = function(success, data) {
    if(success) {
      $.each(data, function(index, value) {
        panel.company.parkings[value.id] = new Parking({id: value.id, name: value.name, latitude: value.lat, longitude: value.lng});
      });

      panel.showOrHideAllMarkersBasedOnState();
    } else {
      if(data.status == 411) {
        location.reload();
      }

      $("#api_connection_error_dialog").dialog("open");
    }
  }

  // Token Update
  this.onTokenUpdated = function(success, data) {}
}

// Api
function Api(args) {
  this.token                    = args.token;
  this.USERS_URL                = args.baseUrl + "technoRidesUsersApi/jq_get_user_by";
  this.OPERATIONS_URL           = args.baseUrl + "technoRidesOperationsApi/";
  this.SCHEDULED_OPERATIONS_URL = args.baseUrl + "technoRidesDelayOperationsApi/";
  this.DRIVER_IMAGE_URL         = args.baseUrl + "taxiApi/displayDriverLogoByEmail";
  this.COMPANY_INFORMATION_URL  = args.baseUrl + "technoRidesLoginApi/getCompanyInfo";
  this.PARKINGS_URL             = args.baseUrl + "technoRidesParkingApi/jq_parking";
  this.RELOGIN_URL              = args.reloginUrl;
  this.maxFavorites             = args.maxFavorites;
  this.defaultCountry           = args.defaultCountry;
  this.defaultCcode             = args.defaultCcode;
  this.handler                  = args.handler;

  // Get History
  this.getHistory = function(userId) {
    // Log
    console.log(">> Getting Favorites");

    // That
    var that = this

    $.ajax(
      {
        url     : this.OPERATIONS_URL + "jq_operation_history_by_user",
        dataType: "json",
        data    : {
          user_id: userId,
          token  : this.token,
          max    : this.maxFavorites
        }
      }
    ).done(
      function(data) {
        that.handler.onHistoryGot(true, data);
      }
    ).fail(
      function(data) {
        that.handler.onHistoryGot(false, data);
      }
    );
  }

  // Update Token
  this.updateToken = function() {
    // Log
    console.log(">> Updating Token");

    // That
    var that = this;

    // Relogin
    $.getJSON(
      this.RELOGIN_URL,
      function(data) {
        that.handler.onTokenUpdated(panel.api.token != null, data);
        panel.api.token = data.token;

        if(panel.api.token != null) {
          that.handler.onTokenUpdated(true, data);
        } else {
          // Log
          console.log(">> Error Updating Token");

          that.handler.onTokenUpdated(false, data);

          // Relogin again
          setTimeout(function(){panel.api.updateToken()}, 1000);
        }
      }
    );
    return this.token;
  }

  // Geocode
  this.geocode = function(country, city, street, street_number, action) {
    geocoder = new google.maps.Geocoder();
    geocoder.geocode(
      {
        "address": country + ", " + city + ", " + street +  " " + street_number + ", "
      },
      function(results, status) {
        if(status == google.maps.GeocoderStatus.OK) {
          // Log
          console.log(">> Location found!");

          panel.api.handler.onGeocode(true, results, action);
        } else {
          // Log
          console.log(">> Location not found!");
        }
      }
    );
  }


  // Geocode
  this.geocode_autocompleter = function(address, action) {
    geocoder = new google.maps.Geocoder();
    address += city_user
    geocoder.geocode(
      {
        "address": address,
        "language": language
      },
      function(results, status) {
        if(status == google.maps.GeocoderStatus.OK) {
          // Log
          console.log(">> Location found!");

          panel.api.handler.onGeocode(true, results, action);
        } else {
          // Log
          console.log(">> Location not found!");
        }
      }
    );
  }

  // Create Operation
  this.createOperation = function(operationAttributes) {
    // Log
    console.log(">> Creating Operation");

    // That
    var that = this;

    // JSON
    // Address From
    var address_from_json = {
      "country"  : operationAttributes["country"],
      "ccode"    : operationAttributes["ccode"],
      "city"     : operationAttributes["address_from"]["city"],
      "street"   : operationAttributes["address_from"]["street"],
      "number"   : operationAttributes["address_from"]["street_number"],
      "floor"    : operationAttributes["address_from"]["floor"],
      "apartment": operationAttributes["address_from"]["apartment"],
      "lat"      : operationAttributes["address_from"]["latitude"],
      "lng"      : operationAttributes["address_from"]["longitude"]
    };

    // Address To
    var address_to_json = {
      "country"  : operationAttributes["country"],
      "ccode"    : operationAttributes["ccode"],
      "city"     : operationAttributes["address_to"]["city"],
      "street"   : operationAttributes["address_to"]["street"],
      "number"   : operationAttributes["address_to"]["street_number"],
      "floor"    : operationAttributes["address_to"]["floor"],
      "apartment": operationAttributes["address_to"]["apartment"],
      "lat"      : operationAttributes["address_to"]["latitude"],
      "lng"      : operationAttributes["address_to"]["longitude"]
    };

    // Device
    var device_json = {
      "userType" : "WEB",
      "deviceKey":"Sarasa"
    };

    // Options
    var options_json = {
      "messaging"       : operationAttributes["options"]["messaging"],
      "pet"             : operationAttributes["options"]["pet"],
      "airConditioning" : operationAttributes["options"]["air_conditioning"],
      "smoker"          : operationAttributes["options"]["smoker"],
      "specialAssistant": operationAttributes["options"]["special_assistant"],
      "luggage"         : operationAttributes["options"]["luggage"],
      "vip"             : operationAttributes["options"]["vip"],
      "airport"         : operationAttributes["options"]["airport"],
      "invoice"         : operationAttributes["options"]["invoice"]
    };

    // User
    var user_json = {
      "email"     : operationAttributes["user"]["email"],
      "phone"     : operationAttributes["user"]["phone_number"],
      "first_name": operationAttributes["user"]["name"],
      "last_name" : operationAttributes["user"]["surname"]
    };

    // Scheduled?
    if((operationAttributes["date"] != null) && (operationAttributes["time"] != undefined && operationAttributes["time"].length != 0)) {
      operationDate = operationAttributes["date"];
      operationTime = operationAttributes["time"];


      operationTimeSplitted = operationTime.split(":");

      operationDateTime = new Date(operationDate.getFullYear(), operationDate.getMonth(), operationDate.getDate(), operationTimeSplitted[0], operationTimeSplitted[1]);

      operationDateTimeFormated = $.format.date(operationDateTime, "yyyy-MM-dd HH:mm:ss");

      $.ajax(
        {
          type    : "POST",
          dataType: "json",
          data    : {
            type         : "email",
            is_web_user  : true,
            token        : this.token,
            device       : JSON.stringify(device_json),
            comments     : operationAttributes["comments"],
            user         : JSON.stringify(user_json),
            addressFrom  : JSON.stringify(address_from_json),
            addressTo    : JSON.stringify(address_to_json),
            options      : JSON.stringify(options_json),
            executionTime: operationDateTimeFormated,
            driver_number: operationAttributes.driver_number
          },
          url     : this.SCHEDULED_OPERATIONS_URL + "create_trip"
        }
      ).done(
        function(data) {
          // On Create Scheduled Operation
          that.handler.onScheduledOperationCreated(true, data);
        }
      ).fail(
        function(data) {
          // On Fail
          that.handler.onScheduledOperationCreated(false, data);
        }
      );
    } else {
      $.ajax(
        {
          type    : "POST",
          dataType: "json",
          data    : {
            type         : "email",
            is_web_user  : true,
            token        : this.token,
            rtaxi        : panel.company.rtaxi,
            device       : JSON.stringify(device_json),
            comments     : operationAttributes["comments"],
            user         : JSON.stringify(user_json),
            addressFrom  : JSON.stringify(address_from_json),
            addressTo    : JSON.stringify(address_to_json),
            options      : JSON.stringify(options_json),
            driver_number: operationAttributes.driver_number
          },
          url     : this.OPERATIONS_URL + (operationAttributes.guest == true ? "create_web_trip" : "create_trip")
        }
      ).done(
        function(data) {
          // On Create Operation
          that.handler.onOperationCreated(true, data);
        }
      ).fail(
        function(data) {
          // On Fail
          that.handler.onOperationCreated(false, data);
        }
      );
    }
  }

  // Cancel Scheduled Operaiton
  this.cancelScheduledOperation = function(operationId) {
    // Log
    console.log(">> Cancel Scheduled Operation");

    // That
    var that = this;

    $.ajax(
      {
        url     : this.SCHEDULED_OPERATIONS_URL + "delete_trip",
        dataType: "json",
        data    : {
          token: this.token,
          id   : operationId
        },
      }
    ).done(
      function(data) {
        that.handler.onScheduledOperationCanceled(true, data);
      }
    ).fail(
      function(data) {
        that.handler.onScheduledOperationCanceled(false, data);
      }
    );
  }

  // Assign Scheduled Operaiton
  this.assignScheduledOperation = function(operationId, driverNumber) {
    // Log
    console.log(">> Cancel Scheduled Operation");

    // That
    var that = this;

    $.ajax(
      {
        url     : this.SCHEDULED_OPERATIONS_URL + "edit_trip",
        dataType: "json",
        data    : {
          token        : this.token,
          id           : operationId,
          driver_number: driverNumber
        },
      }
    ).done(
      function(data) {
        that.handler.onScheduledOperationAssigned(true, data);
      }
    ).fail(
      function(data) {
        that.handler.onScheduledOperationAssigned(false, data);
      }
    );
  }

  // Get Scheduled Operations
  this.getScheduledOperations = function() {
    console.log(">> Getting Scheduled Operations");
    var that = this;

    $.ajax(
      {
        url     : this.SCHEDULED_OPERATIONS_URL + "jq_delay_operation_by_company",
        dataType: "json",
        data    : {
          token: this.token
        }
      }
    ).done(
      function(data) {
        that.handler.onScheduledOperationsGot(true, data);
      }
    ).fail(
      function(data) {
        that.handler.onScheduledOperationsGot(false, data);
      }
    );
  }

  // Get Company Information
  this.getCompanyInformation = function() {
    console.log(">> Getting Company Information");
    var that = this;

    $.ajax(
      {
        url     : this.COMPANY_INFORMATION_URL,
        dataType: "json",
        data    : {
          rtaxi: panel.company.rtaxi
        }
      }
    ).done(
      function(data) {
        that.handler.onCompanyInformationGot(true, data);
      }
    ).fail(
      function(data) {
        that.handler.onCompanyInformationGot(false, data);
      }
    );
  }

  // Get Parkings
  this.getParkings = function() {
    console.log(">> Getting Parkings");
    var that = this;

    $.ajax(
      {
        url     : this.PARKINGS_URL,
        dataType: "json",
        data    : {
          token: that.token
        }
      }
    ).done(
      function(data) {
        that.handler.onParkingsGot(true, data.rows);
      }
    ).fail(
      function(data) {
        that.handler.onParkingsGot(false, data.rows);
      }
    );
  }

  // Get Price
  this.getPrice = function(addressFrom, addressTo) {
    console.log(">> Getting Price");
    var that = this;

    $.ajax(
      {
        url     : "http://" + panel.webSocketConnection.host + ":" + "2001" + "/costCalculator/" + encodeURIComponent(that.token) + "/" + addressFrom.join(",") + "/" + addressTo.join(","),
        dataType: "json",
        data    : {
          token: that.token,
          from : JSON.stringify(addressFrom),
          to   : JSON.stringify(addressTo)
        }
      }
    ).done(
      function(data) {
        that.handler.onPriceGot(true, data);
      }
    ).fail(
      function(data) {
        that.handler.onPriceGot(false, data);
      }
    );
  }
}

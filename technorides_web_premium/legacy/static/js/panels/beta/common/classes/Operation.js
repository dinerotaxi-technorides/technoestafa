function Operation(args) {
  this.id                = args.id;
  this.status            = args.status;
  this.latitude          = args.latitude;
  this.longitude         = args.longitude;

  // Guest panel doesn't use createdAt
  if(args.createdAt != undefined && args.createdAt != null) {
    splittedCreatedAt    = args.createdAt.split(" ");
    this.createdAt       = new Date(splittedCreatedAt[0] + "T" + splittedCreatedAt[1]);

    // Firefox needs Date.UTC to work right
    if(navigator.userAgent.toLowerCase().indexOf("firefox") != -1) {
      this.createdAt = Date.UTC(
        this.createdAt.getFullYear(),
        this.createdAt.getMonth(),
        this.createdAt.getDate(),
        this.createdAt.getHours(),
        this.createdAt.getMinutes(),
        this.createdAt.getSeconds(),
        0
      );
    }

    if(this.status != "SCHEDULED") {
      // Base GMT-3
      this.createdAt.setHours(this.createdAt.getHours() + 3);

      this.createdAt = WallTime.UTCToWallTime(this.createdAt, panel.company.timezone);
    } else {
      // Scheduled operation are timezoned by the server
      this.createdAt = WallTime.UTCToWallTime(this.createdAt, "Etc/GMT");
    }

    this.formatedCreatedAt = ("0" + this.createdAt.getDate()).slice(-2) +
                              "/" + ("0" + (this.createdAt.getMonth() + 1)).slice(-2) + " " +
                             ("0" + this.createdAt.getHours()).slice(-2) + ":" +
                             ("0" + this.createdAt.getMinutes()).slice(-2);
  }

  this.placeFrom         = args.placeFrom;
  this.placeTo           = args.placeTo;
  this.comments          = args.comments;
  this.user              = args.user;
  this.findingDriver     = args.findingDriver;
  this.driver            = null;
  this.driverNumber      = null;
  this.driverId          = null;
  this.amount            = null;
  this.estimatedTime     = null;
  this.assignedAt        = null;
  this.isCompleted       = false;
  

  this.options           = args.options || {};

  // Countdown
  this.displayCountdown = function() {
    console.log(">> Countdown")
    that = this;

    // Countdown
    this.displayEstimatedTimeDiv().countdown({
      until: that.expireTime(),
      format: "HMS",
      compact: true,
      onExpiry: that.displayExpire
    });
  }

  // Div ID
  this.displayDivId = function() {
    // Div ID
    divId = "operation_" + this.id;

    if(this.status == "SCHEDULED")
      divId = "scheduled_" + divId;

    return divId;
  }

  // Display Div
  this.displayDiv = function() {
    // Div
    return $("#" + this.displayDivId());
  }

  // EstimatedTimeDiv
  this.displayEstimatedTimeDiv = function() {
    return this.displayDiv().find(".operation_estimated_time");
  }

  // Expire
  this.displayExpire = function() {
    // Log
    console.log(">> Expiring... (" + this.id + ")");

    // this object is the HTML Object
    operation = panel.company.operations[parseInt($(this).parent().attr("rel"))];
    operation.displayDiv().addClass("operation_expired");
  }

  // Mark as Completed
  this.displayMarkAsCompleted = function() {
    // Mark
    this.isCompleted = true;

    // Div
    operationDiv = this.displayDiv();

    // Remove Right Click menu
    operationDiv.removeClass("pending_operation");
    operationDiv.removeClass("intransaction_operation");
    operationDiv.addClass("completed_operation");

    // Status
    operationDiv.find(".operation_status").html(I18n.panels.operator.statuses[this.status.toLowerCase()]);

    // Driver
    operationDivDriver = operationDiv.find(".operation_driver");
    operationDivDriver.html(this.driverNumber);

    // Amount
    operationDivAmount = operationDiv.find(".operation_amount");
    operationDivAmount.html(this.amount);
    operationDivAmount.show();


    // Estimated time
    operationEstimatedTimeDiv = this.displayEstimatedTimeDiv();
    if(this.estimatedTime != undefined && this.estimatedTime != null) {
      operationEstimatedTimeDiv.countdown("pause");
      operationEstimatedTimeDiv.html(this.estimatedTime + ":00");
    }
    operationEstimatedTimeDiv.show();

    // Refresh
    operationDiv.appendTo("#completed_operations tbody");

    // Remove Marker
    // FIXME: No llamar a map directamente
    panel.map.markers["operation_" + this.id].marker.setMap(null);

    // Counter
    panel.displayUpdateCounters();
  }

  // Mark as In Transaction
  this.displayMarkAsInTransaction = function() {
    // Div
    operationDiv = this.displayDiv();

    // Change Right Click menu
    operationDiv.removeClass("pending_operation");
    operationDiv.addClass("intransaction_operation");

    // Status
    operationDiv.find(".operation_status").html(I18n.panels.operator.statuses[this.status.toLowerCase()]);

    // Driver
    operationDivDriver = operationDiv.find(".operation_driver");
    operationDivDriver.html(this.driverNumber);

    // Amount
    operationDivAmount = operationDiv.find(".operation_amount");
    operationDivAmount.html(this.amount);
    operationDivAmount.show();

    // Estimated time
    operationEstimatedTimeDiv = operationDiv.find(".operation_estimated_time");

    if(this.estimatedTime != undefined && this.estimatedTime != null) {
      this.displayCountdown();
    }

    operationEstimatedTimeDiv.show();

    // Marker
    if(panel.showOperations)
      panel.map.addMarkerOperation(this);

    // Counters
    panel.countMarkers();

    // Refresh
    operationDiv.appendTo("#intransaction_operations tbody");

    // Counter
    panel.displayUpdateCounters();
  }

  // Mark as Pending
  this.displayMarkAsPending = function() {
    // Div
    operationDiv = this.displayDiv();

    // Refresh
    operationDiv.appendTo("#pending_operations tbody");

    // Counter
    panel.displayUpdateCounters();
  }

  // Mark as Scheduled
  this.displayMarkAsScheduled = function() {
    // Div
    operationDiv = this.displayDiv();

    // Refresh
    operationDiv.appendTo("#scheduled_operations tbody");

    // Change Right Click menu
    operationDiv.removeClass("pending_operation");
    operationDiv.addClass("scheduled_operation");

    // Driver
    operationDivDriver = operationDiv.find(".operation_driver");
    operationDivDriver.html(this.driverNumber);

    // Counter
    panel.displayUpdateCounters();
  }

  // Update Display
  this.displayUpdate = function() {
    // Log
    console.log(">> Displaying update... (" + this.id + ")")

    // Status?
    switch(this.status) {
      // COMPLETED
      case "CANCELED":
      case "CANCELED_EMP":
      case "CANCELTIMETRIP":
      case "CALIFICATED":
      case "REJECTTRIP":
      case "COMPLETED":
        this.displayMarkAsCompleted();
        break;

      // PENDING
      case "PENDING":
        this.displayMarkAsPending();
        break;

      // SCHEDULED
      case "SCHEDULED":
        this.displayMarkAsScheduled();
        break;

      // INTRANSACTION
      default:
        this.displayMarkAsInTransaction();
        break;
    }
  }

  // Expire Time
  this.expireTime = function() {
    return new Date(this.assignedAt.getTime() + (this.estimatedTime * 1000 * 60));
  }

  // Update
  this.update = function(json) {
    // Log
    console.log(">> Updating... (" + this.id + ")")

    // Driver? Used when pull trips
    if(json.driver) {
      this.driverId = json.driver;
      if(json.driver.number != undefined)
        this.driverNumber = json.driver.number;
      this.driver = panel.company.drivers[json.driver];
    }

    // Driver? Used when assign trip
    if(json.driverNumber) {
      this.driverNumber = json.driverNumber;
      this.driver = panel.company.drivers[json.driverNumber];
    }

    // Driver? Used when assign trip on scheduled
    if(json.driver_number) {
      this.driverNumber = json.driver_number;
      this.driver = panel.company.drivers[json.driver_number];
    }

    // Status?
    if(operation != undefined && json.status) {
      this.status = json.status;
    }

    // Amount
    if(json.amount) {
      json.amount = json.amount + ""
      json.amount = json.amount.substring(0, json.amount.length - 2);
      this.amount = json.amount;
    }

    // Estimated Time
    if(json.timeEstimated) {
      this.estimatedTime = json.timeEstimated;
    }

    // Assigned At
    if(json.assignedAt) {
      this.assignedAt = new Date();
    }

    // Update Operation
    this.displayUpdate();
  }
}

// New Operation
function newOperation(operationJson) {
  console.log(">> New Operation!");
  // Data
  placeFromJson = operationJson.placeFrom;
  placeToJson   = operationJson.placeTo;
  userJson      = operationJson.user;
  optionsJson   = operationJson.options;
 
  // Place From
  placeFrom = new PlaceFrom(
    {
      street      : placeFromJson.street,
      streetNumber: placeFromJson.streetNumber,
      floor       : placeFromJson.floor,
      appartment  : placeFromJson.appartment,
      latitude    : placeFromJson.lat,
      longitude   : placeFromJson.lng,
      country     : placeFromJson.country,
      locality    : placeFromJson.locality
    }
  );

  if(placeFrom.streetNumber === null)
    placeFrom.streetNumber = "";

  // Place To
  placeTo   = new PlaceTo(
    {
      street      : placeToJson.street,
      streetNumber: placeToJson.streetNumber,
      floor       : placeToJson.floor,
      appartment  : placeToJson.appartment,
      latitude    : placeToJson.lat,
      longitude   : placeToJson.lng,
      country     : placeToJson.country,
      locality    : placeToJson.locality
    }
  );

  if(placeTo.streetNumber === null)
    placeTo.streetNumber = "";

  // User
  user      = new User(
    {
      id         : userJson.id,
      rtaxi      : userJson.rtaxi,
      firstName  : userJson.firstName,
      lastName   : userJson.lastName,
      phone      : userJson.phone,
      language   : userJson.lang,
      cityName   : userJson.cityName,
      cityCode   : userJson.cityCode,
      isFrecuent : userJson.isFrecuent,
      isCC       : userJson.isCC,
      companyName: userJson.companyName
    }
  );
  // Operation
  operation = new Operation(
    {
      id           : operationJson.id,
      status       : operationJson.status,
      latitude     : operationJson.lat,
      longitude    : operationJson.lng,
      createdAt    : operationJson.created_at,
      placeFrom    : placeFrom,
      placeTo      : placeTo,
      comments     : operationJson.comments,
      user         : user,
      options      : {
        messaging       : optionsJson.messaging,
        pet             : optionsJson.pet,
        airConditioning : optionsJson.airConditioning,
        smoker          : optionsJson.smoker,
        specialAssistant: optionsJson.specialAssistant,
        luggage         : optionsJson.luggage,
        vip             : optionsJson.vip,
        airport         : optionsJson.airport,
        invoice         : optionsJson.invoice
      },
      findingDriver: operationJson.finding_driver
    }
  );

  // HTML
  // Options
  optionsHtml = "";
  if(operation.options.messaging == true)
    optionsHtml += img("options/messaging.png");
  if(operation.options.pet == true)
    optionsHtml += img("options/pet.png");
  if(operation.options.airConditioning == true)
    optionsHtml += img("options/air_conditioning.png");
  if(operation.options.smoker == true)
    optionsHtml += img("options/smoker.png");
  if(operation.options.specialAssistant == true)
    optionsHtml += img("options/special_assistant.png");
  if(operation.options.luggage == true)
    optionsHtml += img("options/luggage.png");
  if(operation.options.vip == true)
    optionsHtml += img("options/vip.png");
  if(operation.options.airport == true)
    optionsHtml += img("options/airport.png");
  if(operation.options.invoice == true)
    optionsHtml += img("options/invoice.png");

  if($("#operation_" + operation.id).length == 0) {
    // Operation
    operationHtml = tr("pending_operation", operation.displayDivId(), operation.id, [td("operation_id", operation.id), td("operation_date", operation.formatedCreatedAt.toString("dd-MM-YY")), td("operation_user_phone", operation.user.phone), td("operation_user_full_name", operation.user.fullName()), td("operation_place_from_full_address", operation.placeFrom.fullAddress()), td("operation_place_to_full_address", operation.placeTo.fullAddress()), td("operation_options", optionsHtml), td("operation_comments", operation.comments), td("operation_driver", operation.findingDriver ? I18n.panels.operator.finding_driver : I18n.panels.operator.driver_not_found), "<td class='operation_amount' style='display: none'></td>", "<td class='operation_estimated_time' style='display: none'></td>", td("operation_corporate", (operation.user.isCC ? "&#x2713;" : "&#x2717;")), td("operation_status", I18n.panels.operator.statuses[operation.status.toLowerCase()])]);
    $("#pending_operations tbody").append(operationHtml);

    // Sound
    if(operation.status == "PENDING") {
      playNewTripSound();
    }

    // Status?
    if(operation.status != "PENDING") {
      // Update
      operation.update(operationJson);
    }
  }

  // Counter
  panel.displayUpdateCounters();

  // Return
  return operation;
}

// Validate Email
function validateEmail(email) {
  return /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/.test(email);
}

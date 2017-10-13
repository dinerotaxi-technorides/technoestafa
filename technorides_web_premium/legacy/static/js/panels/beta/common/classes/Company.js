function Company(args) {
  this.id         = args.id;
  this.email      = args.email;
  this.rtaxi      = args.rtaxi;
  this.name       = args.name;
  this.domain     = args.domain;
  this.latitude   = args.latitude;
  this.longitude  = args.longitude;
  this.drivers    = {};
  this.operations = {};
  this.parkings   = {};
  this.timezone   = args.timezone;

  this.configuration = {};

  // Add Driver
  this.addDriver = function(driver) {
    // Existing driver?
    if(this.drivers[driver.id] == null) {
      this.drivers[driver.id] = driver;
    }
    else {
      this.drivers[driver.id].status = driver.status;
      // Latitude
      if(driver.latitude != undefined) {
        this.drivers[driver.id].latitude = driver.latitude;
      }
      // Longitude
      if(driver.longitude != undefined) {
        this.drivers[driver.id].longitude = driver.longitude;
      }
    }
    return(this.drivers[driver.id]);
  }

  // Has Driver?
  this.hasDriver = function(driverId) {
    return this.drivers[driverId] !== undefined;
  }

  // Add Operation
  this.addOperation = function(operation) {
    this.operations[operation.id] = operation;
  }

  // Cancel Operation
  this.cancelOperation = function(operationId) {
    panel.webSocketConnection.send({
      action: "company/CancelTrip",
      id    : this.id,
      rtaxi : this.rtaxi,
      opid  : operationId,
      status: "CANCELED_EMP"
    });
  }

  // Finish Operation
  this.finishOperation = function(operationId) {
    panel.webSocketConnection.send({
      action: "company/FinishTrip",
      id    : this.id,
      rtaxi : this.rtaxi,
      opid  : operationId,
      status: "COMPLETED"
    });
  }

  // Assign Driver
  this.assignOperation = function(operationId, driverNumber, timeEstimated) {
    panel.webSocketConnection.send({
      action       : "company/AssignTrip",
      id           : this.id,
      rtaxi        : this.rtaxi,
      opid         : operationId,
      driverNumber : driverNumber,
      email        : driverNumber + "@" + this.domain,
      timeEstimated: timeEstimated,
      status       : "ASSIGNEDTAXI"
    });
  }

  // Set Amount
  this.setOperationAmount = function(operationId, amount) {
    panel.webSocketConnection.send({
      action: "company/SetAmount",
      id    : this.id,
      rtaxi : this.rtaxi,
      opid  : operationId,
      amount: amount + "00"
    });
  }

  // Ring user
  this.ringUserOperation = function(operationId) {
    panel.webSocketConnection.send({
      action: "driver/RingUser",
      opid  : operationId,
      status: "HOLDINGUSER"
    });
  }

  // In Transaction
  this.inTransactionOperation = function(operationId) {
    panel.webSocketConnection.send({
      action: "driver/InTransactionTrip",
      opid  : operationId,
      status: "INTRANSACTION"
    });
  }

  // Search driver
  this.findDriverOperation = function(operationId) {
    panel.webSocketConnection.send({
      action: "company/findDriver",
      opid  : operationId
    });
  }
}

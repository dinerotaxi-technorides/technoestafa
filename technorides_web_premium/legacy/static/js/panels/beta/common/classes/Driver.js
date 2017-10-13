function Driver(args) {
  this.id        = args.id;
  this.number    = args.number;
  this.status    = args.status;
  this.latitude  = args.latitude;
  this.longitude = args.longitude;
  this.version   = args.version;
  this.firstName = args.firstName;
  this.lastName  = args.lastName;
  this.phone     = args.phone;
  this.email     = args.email;
  this.carBrand  = args.carBrand;
  this.carModel  = args.carModel;
  this.carPlate  = args.carPlate;

  // Full Name
  this.fullName = function() {
    return(this.firstName + " " + this.lastName);
  };

  // Car
  this.car = function() {
    return(this.carBrand + " " + this.carModel);
  };

  // Marker
  this.getMarker = function() {
    return panel.map.markers["driver_" + this.number];
  };

  this.getMarkerStatus = function() {
    var driverStatus = this.status.toLowerCase();

    if(driverStatus != "online" && driverStatus != "disconnected" && driverStatus != "offline")
      driverStatus = "intravel";

    return driverStatus.toUpperCase();
  };
}


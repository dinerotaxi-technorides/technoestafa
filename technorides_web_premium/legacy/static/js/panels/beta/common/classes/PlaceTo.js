function PlaceTo(args) {
  this.street       = args.street;
  this.streetNumber = args.streetNumber;
  this.floor        = args.floor;
  this.appartment   = args.appartment;
  this.latitude     = args.latitude;
  this.longitude    = args.longitude;
  this.country      = args.country;
  this.locality     = args.locality;

  // Full Address
  this.fullAddress = function() {
    return this.street + " " + this.streetNumber;
  }
}

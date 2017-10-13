function PlaceFrom(args) {
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
    fullAddressReturn = this.street + " " + this.streetNumber;

    if(this.floor != null)
      fullAddressReturn += " " + this.floor;

    if(this.appartment != null)
      fullAddressReturn += " " + this.appartment;

    return fullAddressReturn;
  }
}

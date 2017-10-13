function User(args) {
  this.id          = args.id;
  this.rtaxi       = args.rtaxi;
  this.firstName   = args.firstName;
  this.lastName    = args.lastName;
  this.phone       = args.phone;
  this.language    = args.language;
  this.cityName    = args.cityName;
  this.cityCode    = args.cityCode;
  this.isFrecuent  = args.isFrecuent;
  this.isCC        = args.isCC;
  this.companyName = args.companyName;

  // Full Name
  this.fullName = function() {
    return this.firstName + " " + this.lastName;
  }
}

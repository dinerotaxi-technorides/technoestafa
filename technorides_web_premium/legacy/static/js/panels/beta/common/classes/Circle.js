function Circle(args) {
  this.map            = args.map;
  this.id             = args.id;
  this.latitude       = args.latitude;
  this.longitude      = args.longitude;
  this.radius         = args.radius;
  this.color          = args.color;
  this.background     = args.background;

  // Show
  this.show = function() {
    this.circle = new google.maps.Circle({
      strokeColor  : this.color,
      strokeOpacity: 0.8,
      strokeWeight : 2,
      fillColor    : this.background,
      fillOpacity  : 0.2,
      map          : this.map,
      center       : new google.maps.LatLng(this.latitude, this.longitude),
      radius       : this.radius
    });
  }
}

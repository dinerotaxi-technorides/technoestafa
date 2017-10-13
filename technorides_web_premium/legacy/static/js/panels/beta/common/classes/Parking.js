function Parking(args) {
  this.id        = args.id;
  this.name      = args.name;
  this.latitude  = args.latitude;
  this.longitude = args.longitude;

  // Marker
  this.getMarker = function() {
    return panel.map.markers["parking_" + this.id];
  };
}

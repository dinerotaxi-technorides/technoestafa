function Marker(args) {
  this.map            = args.map;
  this.id             = args.id;
  this.latitude       = args.latitude;
  this.longitude      = args.longitude;
  this.icon           = args.icon;
  this.label          = args.label;
  this.infoWindowText = args.infoWindowText;
  this.draggable      = args.draggable;

  if(this.label === undefined)
    this.label = "";

  // Show
  this.show = function() {
    // LatLng
    latLng = new google.maps.LatLng(this.latitude, this.longitude);

    if(this.infoWindowText != "")
      // Info Window
      this.infoWindow = new google.maps.InfoWindow({
        content: this.infoWindowText
      });

    // Marker
    this.marker = new MarkerWithLabel({
      position         : latLng,
      map              : this.map,
      icon             : this.icon,
      labelContent     : this.label,
      labelClass       : this.label == "" ? "" : "marker_label",
      labelAnchor      : new google.maps.Point(this.label.toString().length * 3.5, 30),
      labelInBackground: false,
      draggable        : this.draggable
    });

    // ID
    this.marker.markerId = this.id;

    if(this.infoWindowText != "")
      // Listener
      this.addInfoWindow(this, this.infoWindowText);
  }

  // Add Info Window
  this.addInfoWindow = function(marker, message) {
    // Info Window
    marker.infoWindow = new google.maps.InfoWindow({
      content: message
    });

    // Listener
    google.maps.event.addListener(
      marker.marker,
      "click",
      function() {
        // Open Info Window
        marker.infoWindow.open(marker.map, marker.marker);
      }
    );
  }

  // Set Icon
  this.setIcon = function(newIcon) {
    this.icon = newIcon;
    this.marker.setIcon(this.icon);
  }

  // Set Position
  this.setPosition = function(newLatitude, newLongitude) {
    this.latitude  = newLatitude;
    this.longitude = newLongitude;
    latLng         = new google.maps.LatLng(this.latitude, this.longitude);
    this.marker.setPosition(latLng);
  }

  // Update
  this.update = function(newLatitude, newLongitude, newIcon) {
    this.setPosition(newLatitude, newLongitude);
    this.setIcon(newIcon);
  }
}

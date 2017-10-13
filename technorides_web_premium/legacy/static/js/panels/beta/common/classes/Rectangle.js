function Rectangle(args) {
  this.map        = args.map;
  this.id         = args.id;
  this.latitude1  = args.latitude1;
  this.longitude1 = args.longitude1;
  this.latitude2  = args.latitude2;
  this.longitude2 = args.longitude2;
  this.color      = args.color;
  this.background = args.background;
  this.editable   = args.editable;
  this.draggable  = args.draggable;

  this.bounds     = new google.maps.LatLngBounds(
    new google.maps.LatLng(this.latitude1, this.longitude1),
    new google.maps.LatLng(this.latitude2, this.longitude2)
  );

  // Show
  this.show = function() {
    this.rectangle = new google.maps.Rectangle({
      strokeColor  : this.color,
      strokeOpacity: 0.8,
      strokeWeight : 2,
      fillColor    : this.background,
      fillOpacity  : 0.2,
      map          : this.map,
      bounds       : this.bounds,
      editable     : this.editable,
      draggable    : this.draggable
    });

    // ID
    this.rectangle.rectangleId = this.id;
  }

  this.hasValidBounds = function() {
    that = this;
    validBounds = true;
    $.each(panel.map.rectangles, function(index, value) {
      if(
        that.id != value.id && (
          (
            // X
            // 1 1' 2
            (that.longitude1 <= value.longitude1 && that.longitude2 >= value.longitude1) ||
            // 1 2' 2
            (that.longitude1 <= value.longitude2 && that.longitude2 >= value.longitude2) ||
            // 1 1' 2' 2
            (that.longitude1 <= value.longitude1 && that.longitude2 >= value.longitude2) ||
            // 1' 1 2 2'
            (that.longitude1 >= value.longitude1 && that.longitude2 <= value.longitude2)
          ) && (
            // Y
            // 1 1' 2
            (that.latitude1 <= value.latitude1 && that.latitude2 >= value.latitude1) ||
            // 1 2' 2
            (that.latitude1 <= value.latitude2 && that.latitude2 >= value.latitude2) ||
            // 1 1' 2' 2
            (that.latitude1 <= value.latitude1 && that.latitude2 >= value.latitude2) ||
            // 1' 1 2 2'
            (that.latitude1 >= value.latitude1 && that.latitude2 <= value.latitude2)
          )
        )
      ) {
        console.log("Invalid bounds! (" + that.id + "/" + value.id + ")");
        validBounds = false;
      }
    });
    return validBounds;
  }
}

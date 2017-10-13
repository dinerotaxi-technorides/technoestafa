(function($){

  function Place() {
    this.o = new Object();
    
    // Usage:
    //   var data = { 'first name': 'George', 'last name': 'Jetson', 'age': 110 };
    //   var querystring = EncodeQueryData(data);
    // 
    this.encode = function() {
       var ret = [];
       for (var d in this.o)
          ret.push(encodeURIComponent(d) + "=" + encodeURIComponent(this.o[d]));
       return ret.join("&");
    }
    
    this.encodeDelete = function() {
       var ret = [];
       ret.push(encodeURIComponent('id') + "=" + encodeURIComponent(this.o['id']));
       return ret.join("&");
    }
    
    this.location = function() {
       return new google.maps.LatLng(this.o.lat, this.o.lng);
    }
    
    this.bounds = function() {
      var sw = new google.maps.LatLng(this.o.southWestLatBound, this.o.southWestLngBound);
      var ne = new google.maps.LatLng(this.o.northEastLatBound, this.o.northEastLngBound);
      return new google.maps.LatLngBounds(sw, ne);
    }
    
    this.addGeocoderResult = function(geocoderResult) {
    
        this.o.name = geocoderResult.formatted_address;
        this.o.lat = geocoderResult.geometry.location.lat();
        this.o.lng = geocoderResult.geometry.location.lng();
        this.o.northEastLatBound = geocoderResult.geometry.viewport.getNorthEast().lat();
        this.o.northEastLngBound = geocoderResult.geometry.viewport.getNorthEast().lng();
        this.o.southWestLatBound = geocoderResult.geometry.viewport.getSouthWest().lat();
        this.o.southWestLngBound = geocoderResult.geometry.viewport.getSouthWest().lng();
        this.o.country = this.find(geocoderResult, 'country');
        this.o.countryCode = this.find_short(geocoderResult, 'country');
        this.o.locality = this.find(geocoderResult, 'locality');
        this.o.admin1Code = this.find(geocoderResult, 'administrative_area_level_1');
        this.o.admin2Code = this.find(geocoderResult, 'administrative_area_level_2');
        this.o.admin3Code = this.find(geocoderResult, 'administrative_area_level_3');
        this.o.street = this.find(geocoderResult, 'route');
        this.o.streetNumber = this.find(geocoderResult, 'street_number');
        this.o.postalCode = this.find(geocoderResult, 'postal_code');
        this.o.locationType = geocoderResult.geometry.location_type;
        this.o.type = geocoderResult.types[0];
    }
    
    this.find = function(geocoderResult, type) {
        // code for display method goes here
        for(var j=0;j < geocoderResult.address_components.length; j++){
            for(var k=0; k < geocoderResult.address_components[j].types.length; k++){
                if(geocoderResult.address_components[j].types[k] == type){
                    return geocoderResult.address_components[j].long_name;
                }
            }
        }    
        return ""
    }
    
    this.find_short = function(geocoderResult, type) {
        // code for display method goes here
        for(var j=0;j < geocoderResult.address_components.length; j++){
            for(var k=0; k < geocoderResult.address_components[j].types.length; k++){
                if(geocoderResult.address_components[j].types[k] == type){
                    return geocoderResult.address_components[j].short_name;
                }
            }
        }    
        return ""
    }
  }

  $.fn.geoplaces = function(options) {
    var settings = $.extend({
      placePane: 'div.geoplacePane',
      placeTemplate: 'div.template.place',
      map: '',
      get: 'places/get',
      add: 'places/add',
      del: 'places/remove',
      delay: 1000
    },options||{});

    function savePlace(geocoderResult) {
        say('Save place');
        var pl = new Place;
        pl.addGeocoderResult(geocoderResult);
        
        jQuery.ajax({
          url: settings.add,
          type: "POST",
          //data: {place: JSON.stringify(pl)},
          //data: {name: pl.name, lat: pl.lat },
          data: pl.encode(),
          dataType: "json",
          complete:function(data,textStatus) {
 	        say('complete');
          },
          success:function(data,textStatus) {
 	        say('success: ' + data.id);
 	        pl.o = data;
 	        addPlace(pl);
          },
          error:function(data,textStatus) {
 	        say('error');
          }
        });
        
        return pl;
    }
    
    function deletePlace(item) {
        say('Delete place');
        var place = $(item).closest('div.filterItem').data('place');
        jQuery.ajax({
          url: settings.del,
          type: "POST",
          data: place.encodeDelete(),
          dataType: "json",
          complete:function(data,textStatus) {
 	        say('complete');
          },
          success:function(data,textStatus) {
 	        say('success...');
            var marker = $(item).closest('div.filterItem').data('marker');
            //marker.setMap(null);
            marker.setVisible(false);
            $(item).closest('div.filterItem').remove();
            say('removing place');
            zoomToFit();
          },
          error:function(data,textStatus) {
 	        say('error');
          }
        });
    }
    
    function addPlace(pl){
        say('Add place');
        var filterItem = $('<div>')
        .addClass('filterItem')
        .appendTo(settings.placePane)
        .data('suffix',settings.placePane + (settings.filterCount++))
        .data('pos', settings.filterCount)
        .attr('id', 'filterItem_'+ settings.placePane + '_' + (settings.filterCount))
        .data('place', pl);
        
        $(settings.placeTemplate)
          .children().clone().appendTo(filterItem);
          
        filterItem.children('input').val(pl.o.name);
        
        var marker = new google.maps.Marker({
              position: pl.location(), 
              map: $(settings.map).data('map'), 
              title: pl.o.name
          });
        filterItem.data('marker', marker);
        zoomToFit();
    }
    
    function zoomToFit(){
        say('Zoom to fit');
        //  Create a new viewpoint bound
        var bounds = null;
        //  Go through each marker...
        $('div.filteritem').each(function(){
            if(bounds != null){
                //  Increase the bounds to take this point
                var pos = $(this).data('marker').getPosition();
                bounds.extend(pos);
                say('extend ' + pos);
            }
            else {
                // Initial bound use viewport for geocoder result
                bounds = $(this).data('place').bounds();
                say('init ' + bounds);
            }
        });
        if(bounds){
            //  Fit these bounds to the map
            say('Fitbounds');
            $(settings.map).data('map').fitBounds(bounds);
        }
    }
    
    function initMap(){
      var mapitem = $(settings.map)
      if(!mapitem.data('map')){
        say('Init map...');
        var latlng = new google.maps.LatLng(2.659,-4.714);
        var mapOptions = {
            zoom: 1,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
            };
        
        var map = new google.maps.Map(mapitem.get(0), mapOptions);
        var geocoder = new google.maps.Geocoder();
        mapitem.data('map', map)
            .data('geocoder', geocoder);
      }
    }
    
    // Initialize the map
    initMap();

    settings.filterCount = 0;
    
    $(settings.placePane + ' div button').live('click',function(){
      deletePlace(this);
    });
    
    this.autocomplete({
      //This bit uses the geocoder to fetch address values
      source: function(request, response) {
        say('geocode ' + request.term)
        $(settings.map).data('geocoder').geocode( {'address': request.term, 'language': 'es' }, function(results, status) {
          response($.map(results, function(item) {
            return {
              label: item.formatted_address,
              value: item.formatted_address,
              geocoderResult: item
            }
          }));
        })
      },
      //This bit is executed upon selection of an address
      select: function(event, ui) {
        $(this).val("");        
        say('Address selected ' + ui.item.value);
        savePlace(ui.item.geocoderResult);
        return false;
      }
    });

    return this;
  };
  function checkBounds() {    
      if(! allowedBounds.contains(map.getCenter()))
      {
          var C = map.getCenter();
          var X = C.lng();
          var Y = C.lat();
          var AmaxX = allowedBounds.getNorthEast().lng();
          var AmaxY = allowedBounds.getNorthEast().lat();
          var AminX = allowedBounds.getSouthWest().lng();
          var AminY = allowedBounds.getSouthWest().lat();
          if (X < AminX) {X = AminX;}
          if (X > AmaxX) {X = AmaxX;}
          if (Y < AminY) {Y = AminY;}
          if (Y > AmaxY) {Y = AmaxY;}
          map.panTo(new google.maps.LatLng(Y,X));
      } 
  }
})(jQuery);


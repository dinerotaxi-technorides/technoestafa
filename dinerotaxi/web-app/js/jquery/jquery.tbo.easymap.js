(function($){

    $.fn.easymap = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() { $(this).easymap(customOptions) });
            return this;
        }

        // SETUP private variables;
        var base = this;
        var count = 0;
        var geocoder = null;

        // setup options
        var defaultOptions = {
            //default options go here.
            pre : null,
            map : null,
            debug : false
        };

        var options = $.extend({}, defaultOptions, customOptions);
        
        // SETUP private functions;
        var intialize = function() {
            options.pre = base.attr("pre");
            options.map = base;
            if(options.pre!='[]'){
                geocoder = new google.maps.Geocoder();
                initMap();
                prePopulate();
            }
            return base;
        };
        
        var prePopulate = function() {
            var data = eval (options.pre);
            if(options.pre){
                $.each(data, function (i, value) {
                    var res = compileResult(value.id);
                    addPlace(res);
                });
            }
        }
        
        var addPlace = function(res) {
//            console.log("%s: %o", 'easymap add place', base);

            var fieldItem = $('<div>')
            .addClass('field-group field-value')
            .appendTo(base)
            
            addDotOnMap(fieldItem, res);
            count++;
            updateHiddenValueNames();
        };        
        
        var compileResult = function (json) {
          var o = JSON.parse(json.replace(/\'/g, '\"'));
          o.latlng = new google.maps.LatLng(o.lat,o.lng);
          var sw = new google.maps.LatLng(o.southWestLatBound,o.southWestLngBound);
          var ne = new google.maps.LatLng(o.northEastLatBound,o.northEastLngBound);
          o.viewport = new google.maps.LatLngBounds(sw, ne);
          return o;
        }
        
        var updateHiddenValueNames = function() {
          $(options.fieldinput).find('.hidden-value').each(function(i){
            var itemname = options.hiddenvaluename + '[' + i + ']';
            $(this).attr('name', itemname);
          });
        }
        
        var initMap = function() {
          var mapitem = $(options.map)
          if(!mapitem.data('map')){
            var latlng = new google.maps.LatLng(41.659,-4.714);
            var mapOptions = {
                zoom: 1,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
                };
            
            var map = new google.maps.Map(mapitem.get(0), mapOptions);
            mapitem.data('map', map);
          }
        }
        
        var addDotOnMap = function(item, res) {
            var marker = new google.maps.Marker({
                  position: res.latlng, 
                  map: $(options.map).data('map'), 
                  title: res.name
              });
            item.data('marker', marker);
            item.data('position', res.latlng);
            item.data('bounds', res.viewport);
            zoomToFit();
        }
        
        var zoomToFit = function() {
            //  Create a new viewpoint bound
            var bounds = null;
            //  Go through each marker...
            $(base).children(".field-value").each(function(){
                if(bounds != null){
                    //  Increase the bounds to take this point
                    var pos = $(this).data('position');
                    bounds.extend(pos);
                }
                else {
                    // Initial bound use viewport for geocoder result
                    bounds = $(this).data('bounds');
                }
            });
            if(bounds){
                //  Fit these bounds to the map
                $(options.map).data('map').fitBounds(bounds);
            }
        }
        
        // PUBLIC functions
        this.reload = function() {
//            console.log("%s: %o", 'easymap reload', base);
            //todo
        };

        return intialize();
    }

})(jQuery);


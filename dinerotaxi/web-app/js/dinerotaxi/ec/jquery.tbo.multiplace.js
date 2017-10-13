

(function($){

	
    $.fn.multiplace = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() { $(this).multiselect(customOptions) });
            return this;
        }

        // SETUP private variables;
        var base = this;
        var count = 0;
        var geocoder = null;

        // setup options
        var defaultOptions = {
            //default options go here.
            beforeLoad : function() {
                            // do something .
                        },
            afterLoad : function() {
                            // do something .
                        },
            debug : true,
            pre : null,
            map : null,
            val : '',
            field : '<div>', // <div class="field-group deleteable">
            input : '<input>', // <input type="text" name="coke" value="Ski" id="coke" readonly="readonly" />
            link  : '<a>', // <a class="delete" href="">Delete</a></div>
            group : null,
            preventDuplicates: false,
            tokenLimit: null,
            hiddenvaluename: 'values'
        };

        var options = $.extend({}, defaultOptions, customOptions);
        
        // SETUP private functions;
        var intialize = function() {
//            console.log("%s: %o", 'multiplace init', base);
            options.group = base.closest("div.field-group");
            options.fieldinput = base.closest("div.field-input");
            options.pre = base.attr("pre");
            options.map = base.attr("map");
            geocoder = new google.maps.Geocoder();
            initMap();
            prePopulate();
            bindEvents();
            return base;
        };

        var addPlace = function(value, id, res) {
//            console.log("%s: %o", 'multiplace add place', base);

            var fieldItem = $('<div>')
            .addClass('field-group field-value deleteable')
            //.insertAfter(options.group)
            .insertBefore(options.group)
            
            var hiddenItem = $(options.input)
            .attr('type', 'hidden')
            .addClass('hidden-value')
            .val(id)
            .appendTo(fieldItem)

            var inputItem = $(options.input)
            .attr('type', 'text')
            .attr('readonly', 'readonly')
            .appendTo(fieldItem)

            inputItem.val(value);

            var linkItem = $(options.link)
            .addClass('delete')
            .attr('href', '')
            .appendTo(fieldItem)

            linkItem.bind('click.multiplace',function(e){
              e.preventDefault();
              deletePlace(this);
            });
            
            addDotOnMap(fieldItem, res);
            count++
            checkTokenLimit(value);
            updateHiddenValueNames();
        };
        
        var prePopulate = function() {	
            var data = eval (options.pre);
            if(options.pre){
                $.each(data, function (i, value) {
                    var res = compileResult(value.id);
                    addPlace(value.name, value.id, res);
                });
            }
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
            var latlng = new google.maps.LatLng(-0.2166667,-78.51666670000003);
            var mapOptions = {
                zoom: 15,
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
            $(options.fieldinput).children(".field-value").each(function(){
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

        var deletePlace = function(item) {
//          console.log("%s: %o", 'multiplace delete place', base);
          
          var marker = $(item).closest('div.field-group').data('marker');
          
          $(item).unbind('.multiplace');
          $(item).closest('div.field-group').remove();
          deleteBase();
          $(base).show();
          count--;
          
          //marker.setVisible(false);
          marker.setMap(null);
          zoomToFit();
          updateHiddenValueNames();
        };

        var checkTokenLimit = function (vlu) {
          if(options.tokenLimit !== null && count >= options.tokenLimit) {
            $(base).hide(); 
            $(base).val(vlu);
            return;
          }
        }

        var deleteBase = function () {
          if(options.tokenLimit !== null && count >= options.tokenLimit) {
            $(base).val("");
            return;
          }
        }
        
        var find = function(geocoderResult, type) {
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

        var find_short = function(geocoderResult, type) {
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

        var parseResult = function (geocoderResult) {
          var o = new Object();
          o.name = geocoderResult.formatted_address;
          o.lat = geocoderResult.geometry.location.lat();
          o.lng = geocoderResult.geometry.location.lng();
          o.northEastLatBound = geocoderResult.geometry.viewport.getNorthEast().lat();
          o.northEastLngBound = geocoderResult.geometry.viewport.getNorthEast().lng();
          o.southWestLatBound = geocoderResult.geometry.viewport.getSouthWest().lat();
          o.southWestLngBound = geocoderResult.geometry.viewport.getSouthWest().lng();
          o.country = find(geocoderResult, 'country');
          o.countryCode = find_short(geocoderResult, 'country');
          o.locality = find(geocoderResult, 'locality');
          o.admin1Code = find(geocoderResult, 'administrative_area_level_1');
          o.admin2Code = find(geocoderResult, 'administrative_area_level_2');
          o.admin3Code = find(geocoderResult, 'administrative_area_level_3');
          o.street = find(geocoderResult, 'route');
          o.streetNumber = find(geocoderResult, 'street_number');
          o.postalCode = find(geocoderResult, 'postal_code');
          o.locationType = geocoderResult.geometry.location_type;
          o.type = geocoderResult.types[0];
          
          o.latlng = geocoderResult.geometry.location;
          o.viewport = geocoderResult.geometry.viewport;
          return o;
        }
        
        var compileResult = function (json) {
          var o = JSON.parse(json.replace(/\'/g, '\"'));
          o.latlng = new google.maps.LatLng(o.lat,o.lng);
          var sw = new google.maps.LatLng(o.southWestLatBound,o.southWestLngBound);
          var ne = new google.maps.LatLng(o.northEastLatBound,o.northEastLngBound);
          o.viewport = new google.maps.LatLngBounds(sw, ne);
          return o;
        }

        var bindEvents = function () {
            // bind the close event to any element with the closeClass class
            $(base).bind('click.multiplace', function (e) {
                e.preventDefault();
//                console.log("%s: %o", 'multiplace click ' + options.val, base);
            });
            
            $(base).autocomplete({
              //This bit uses the geocoder to fetch address values
              source: function(request, response) {
                geocoder.geocode( {'address': request.term}, function(results, status) {
                  response($.map(results, function(item) {
                    return {
                      label: item.formatted_address,
                      value: item.formatted_address,
                      result: item
                    }
                  }));
                })
              },
              //This bit is executed upon selection of an address
              select: function(event, ui) {
                $(this).val("");
                var o = parseResult(ui.item.result);
                var res = JSON.stringify(o);
                var res = res.replace(/[\']/g, '\\\'');
                var res = res.replace(/[\"]/g, '\'');
//                console.log("%s: %o", 'multiplace result ' + res, base);
                //sss
                addPlace(ui.item.label, res, o);
                return false;
              }
            });
        };
               
        // PUBLIC functions
        this.changeTab = function() {
            // change Tab
        };

        return intialize();
    }

})(jQuery);


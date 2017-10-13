(function($){
    $.widget( "custom.searchcomplete", $.ui.autocomplete, {
        _renderMenu: function( ul, items ) {
            var self = this,
                currentCategory = "";
            $.each( items, function( index, item ) {
                if ( item.category != currentCategory ) {
                    ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
                    currentCategory = item.category;
                }
                self._renderItem( ul, item );
            });
        }
    });
    
    $.fn.search = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() { $(this).search(customOptions) });
            return this;
        }

        // SETUP private variables;
        var base = this;

        // setup options
        var defaultOptions = {
            //default options go here.
            beforeLoad : function() {
                            // do something .
                        },
            afterLoad : function() {
                            // do something .
                        },
            debug : false
        };

        var options = $.extend({}, defaultOptions, customOptions);
        
        // SETUP private functions;
        var intialize = function() {
//            console.log("%s: %o", 'search init', base);
            options.source = base.attr("source");
            bindEvents();
            return base;
        };
        
        var bindEvents = function () {
            var obj = $(base).autocomplete({
              //This bit uses the geocoder to fetch address values
              source: options.source,
              //This bit is executed upon selection of an address
              select: function(event, ui) {
                //$(this).val("");
//                console.log("%s: %o", 'search select ' + ui.item.link +' '+ $(this).val(), base);
                //window.location.replace(ui.item.link+' +text:'+ $(this).val());
                window.location.replace(ui.item.link);
                return false;
              }
            });
            
            obj.data("autocomplete")._resizeMenu = function () {
              var ul = this.menu.element;
              ul.innerWidth(400);
            }
                      
            obj.data( "autocomplete" )._renderMenu = function(ul, items) {
              var self = this, currentCategory = "";
              
              $(ul).addClass('ui-search');
              
              $.each( items, function( index, item ) {
	              if ( item.category != currentCategory ) {

	                $('<li>')
                    .addClass('ui-menu-category')
                    .text(item.category)
                    .appendTo(ul);

		              currentCategory = item.category;
	              }
	              self._renderItem( ul, item );
              });
            };

            obj.data( "autocomplete" )._renderItem = function( ul, item ) {
//              console.log("%s: %o", 'item ' + item.value, base);
              
              var menuItem = $('<li></li>')
                .data( "item.autocomplete", item )
                              
              if(item.value == "View all") {
                menuItem
                  .addClass("ui-menu-view-all")
		              .append( "<a href=''>" + item.label + "</a>" );
              }
              else {
                menuItem
		              .append( "<a href='" + item.link + "'><img src='" + item.avatar + "' alt='' /><dl><dt>" + item.label + "</dt><dd>" + item.desc + "</dd></dl></a>" );
		          }

              return menuItem
                .appendTo( ul );
              
	            //return $( "<li></li>" )
		          //  .data( "item.autocomplete", item )
		          //  .append( "<a>" + item.label + "<br>" + item.desc + "</a>" )
		          //  .appendTo( ul );
            };
            
            $(base).closest('form').submit(function() {
//              console.log("%s: %o", 'searh submit ', base);
              
              var q = $(this).find('#search').val();
              if(!q) q='*';
              
              var hiddenItem = $('<input>')
              .attr('type', 'hidden')
              .attr('name', 'q')
              .val('+text:' + q)
              .appendTo(this)
              //return false;
            });
        };
               
        // PUBLIC functions
        this.changeTab = function() {
            // change Tab
        };

        return intialize();
    }

})(jQuery);


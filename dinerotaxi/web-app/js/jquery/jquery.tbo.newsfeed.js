(function($){

    $.fn.newsfeed = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() { $(this).newsfeed(customOptions) });
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
            $(base).find('textarea').focusin(function() {
//              console.log("%s: %o", 'newsfeed focus in', base);
              show();
            });
            
            $(base).focusout(function() {
//              console.log("%s: %o", 'newsfeed focus out', base);
              //$(base).find('.feed-actions').toggle();
            });
            
            $(base).find('.icon-close').click(function() {
//              console.log("%s: %o", 'newsfeed focus out', base);
              hide();
              return false;
            });

            hide();
            return base;
        };
       
        var hide = function() {
          $(base).find('.feed-actions').hide();
          $(base).find('.icon-close').hide();
          $(base).removeClass('expanded');
        };
        
        var show = function() {
          $(base).addClass('expanded');
          $(base).find('.icon-close').show();
          $(base).find('.feed-actions').show();
        };
        
        // PUBLIC functions
        this.changeTab = function() {
            // change Tab
        };

        return intialize();
    }

})(jQuery);


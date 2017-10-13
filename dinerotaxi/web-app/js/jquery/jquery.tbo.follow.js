(function($){

    $.fn.follow = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() { 
              $(this).follow(customOptions)
            });
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
            url: '',
            initialClass: '',
            groupname: 'follow',
            linkHtml: '<a>',
            debug : false
        };

        var options = $.extend({}, defaultOptions, customOptions);
        
        // SETUP private functions;
        var intialize = function() {
            options.url = base.attr('url');
            bindEvents();
            return base;
        };
               
        var bindEvents = function () {
            // unbind to make sure event is not fired multiple times
            $(base).unbind('.' + options.groupname);
            // bind the click event
            $(base).bind('click.' + options.groupname, function (e) {
                e.preventDefault();
//                console.log("%s: %o", 'click ' + options.url, base);
                post();
                return false;
            });
        };
        
        var post = function() {
          jQuery.ajax({
              url: options.url,
              type: "POST",
              complete:function(data,textStatus) {
//                  console.log("%s: %o", 'post complete', base);
              },
              success:function(data, textStatus, xhr) {
//                  console.log("%s: %o", 'post success', base);
                  if(options.update){
                    var updateable = $(options.update)
                  }
                  else{
                    var updateable = base.find('.updateable');
                  }
                  
                  if(updateable.length == 0) {
                    updateable = base
                  }
                  $(base).unbind('.follow');
                  updateable.replaceWith(data);
                  $(".following.button").follow();
              },
              error:function(data,textStatus) {
//                  console.log("%s: %o", 'post error', base);
              }	
          });
        }        

        // PUBLIC functions
        this.changeTab = function() {
            // change Tab
        };

        return intialize();
    }

})(jQuery);


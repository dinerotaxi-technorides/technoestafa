(function($){

    $.fn.deletable = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() { 
              $(this).deletable(customOptions) 
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
            linkHtml: '<a>',
            debug : false
        };

        var options = $.extend({}, defaultOptions, customOptions);
        
        // SETUP private functions;
        var intialize = function() {
            options.url = base.attr('url');
            addDeleteButton();
            bindEvents();
            return base;
        };
        
        var addDeleteButton = function () {
             var linkItem = $(options.linkHtml)
            .addClass('delete')
            .attr('href', '')
            .appendTo(base)
        };
       
        var bindEvents = function () {
            // unbind to make sure event is not fired multiple times
            $(base).unbind('.deletable');
            // bind the click event
            $(base).find('.delete').bind('click.deletable', function (e) {
                e.preventDefault();
//                console.log("%s: %o", 'editable click ' + options.url, base);
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
                  if(xhr.status==202){              
                      // Form not valid
                  }
                  else{
                      $(base).remove();
                  }
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


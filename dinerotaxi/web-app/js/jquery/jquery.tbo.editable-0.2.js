(function($){
    $.fn.log = function (msg) {
//          console.log("%s: %o", msg, this);
          return this;
      };
      
    $.fn.editable = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() { $(this).editable(customOptions) });
            return this;
        }

        // SETUP private variables;
        var base = this;

        // setup options
        var defaultOptions = {
            //default options go here.
            onShowCallback : null,
            onSubmitCallback : null,
            afterLoad : function() {
                            // do something .
                        },
            debug : false,
            url : '',
            containerId : 'modal-wrapper',
            width: 'auto',
            minHeight: '700',
            update: null
        };

        var options = $.extend({}, defaultOptions, customOptions);
        
        // SETUP private functions;
        var intialize = function() {
//            console.log("%s: %o", 'editable init', base);
//            console.log("%s: %o", 'editable options', options);
            options.url = base.attr('url');
            options.update = base.attr('update');
            bindEvents();
            return base;
        };
        
        var getForm = function() {
//            console.log("%s: %o", 'editable getForm', base);
            /*var pos = base.position();
            if(pos.left>800){
            	pos.left = pos.left - 600 + base.width();
            }
            if(pos.top > $(document).height()-600 ){
            	pos.top = $(document).height()-600;
            }
            options.pos = pos;
            $(window).width()*/
            
            $.get(
                options.url,
                function(response) {
                    $(response).modal({
                    	//position: [options.pos.top-$(window).scrollTop(), options.pos.left],
                        onOpen:onOpen,
                        onShow: onShow,
                        containerId: options.containerId,
                        minHeight: options.minHeight,
                        fixed: false
                    });
                }
            );
        }
        
        var onOpen = function(dialog) {
//          console.log("%s: %o", 'editable onOpen', dialog);
          dialog.container.css("height", "auto");
          dialog.overlay.show();
          dialog.container.show();
          dialog.data.show();
          
          $.modal.setPosition()
        }
        
        var onShow = function(dialog) {
//            console.log("%s: %o", 'editable showModal', base);

            // execute callback if defined
            if (options.onShowCallback != undefined) {
                hooks(dialog, options.onShowCallback);
            }
            // Add submit event listener
            $('.simplemodal-submit').log("submit event").bind('submit.simplemodal', function (e) {
//                console.log("%s: %o", 'editable submit', base);
                e.preventDefault();
                if($(dialog.wrap).find("form").valid()){
//                    console.log("%s: %o", 'editable submit valid', base);
                    post(dialog,false);
                }
            });
            // Add delete event listener
            $('.button-submit.button-delete').log("delete event").bind('click.simplemodal', function (e) {
//                console.log("%s: %o", 'editable delete', base);
                e.preventDefault();
                post(dialog, true);
            });
        }
        
        var post = function(dialog, deleteitem) {
          jQuery.ajax({
              url: options.url,
              type: "POST",
              data: deleteitem ?  'useraction=delete' : $(dialog.wrap).find("form").serialize(),
              complete:function(data,textStatus) {
//                  console.log("%s: %o", 'post complete', base);
              },
              success:function(data, textStatus, xhr) {
//                  console.log("%s: %o", 'post success', data);
                  if(xhr.status==202){              
                      // Form not valid
                      jQuery(options.dialog.wrap).html(data);
                      $.modal.update(300,600);
                      $('.simplemodal-submit').bind('submit.simplemodal', function (e) {
                          e.preventDefault();
                          post(dialog);
                      });
                  }
                  else{
                      if(options.update){
                        if(options.update!='false'){
                          var updateable = $(options.update)
                          if(updateable.length > 0) {
                            updateable.html(data);
                          }
                        }
                      }
                      else{
                        var updateable = base.find('.updateable');
                        if(updateable.length == 0) {
                          updateable = base
                        }
                        updateable.html(data);
                      }                      
                      
                      if (options.onSubmitCallback != undefined) {
                          hooks(data, options.onSubmitCallback);
                      }

                      $.modal.close();
                  }
              },
              error:function(data,textStatus) {
                  console.log("%s: %o", 'post error', base);
              }	
          });
        }        
        
        var bindEvents = function () {
            // unbind to make sure event is not fired multiple times
            $(base).unbind('.editable');
            // bind the click event
            $(base).bind('click.editable', function (e) {
                e.preventDefault();
//                console.log("%s: %o", 'editable click ' + options.url, base);
                getForm();
                return false;
            });
        };
        
        var hooks = function(thisObject, hookList){
            if ($.isFunction(hookList)){
                hookList.apply(base, [thisObject]);
                return true;
            } else if ($.isArray(hookList)) {
                var result = {
                    isOK: true
                };
                for (var i = 0; i < hookList.length; i++) {
                    if (result.isOK) {
                        result = hookList[i].apply(thisObject, [ result.data ]);
                    }
                }
                return result.isOK;
            }else{
                return true;
            }
        }               
               
        // PUBLIC functions
        this.changeTab = function() {
            // change Tab
        };

        return intialize();
    }

})(jQuery);


(function($){

  var methods = {
    // Init method
    init : function( options ) {
      say('Init...');        
      
      // If options exist, lets merge them
      // with our default settings
      if ( options ) { 
        $.extend( settings, options );
      }

      return $(this).each(function(){
        $(this).data('editable', {
          target : $(this),
          url : $(this).attr('url')
        });
        $(this).bind('click.editable', methods.click);
      });
    },
    
    // Destroy method
    destroy : function( ) {
      return $(this).each(function(){
      })
    },
    
    // Editable field click handler
    click : function( ) { 
      say('click');
      
      settings.url = $(this).attr('url')
      settings.pos = $(this).position();
      settings.orig = this;
      
      $.get(
          settings.url,
          function(response) {                            
              $(response).modal({
                  position: [settings.pos.top-$(window).scrollTop(), settings.pos.left],
                  onShow: methods.show
              });
          }
      );
      return false;
    },
    
    post : function(dialog) {
      say('post');
      
      jQuery.ajax({
          url: settings.url,
          type: "POST",
          data: jQuery(dialog.data).serialize(),
          complete:function(data,textStatus) {
              say('complete');
          },
          success:function(data,textStatus,xhr) {
              say('success');
              if(xhr.status==202){              
                  // Form not valid
                  jQuery(settings.dialog.wrap).html(data);
                  $.modal.update(300,600);
                  $('.simplemodal-submit').bind('submit.simplemodal', function (e) {
                      e.preventDefault();
                      methods.post(dialog);
                  });
                  // jQuery('.simplemodal-wrap').html('<div class="popup simplemodal-data" id="login-popup" style="display: block;">'+jQuery("#login-popup").html()+'</div>');
                  // jQuery('.simplemodal-close').click(function() {jQuery.modal.close(); return false;});
                  //$.modal.close();
                  //setTimeout(function () {
                  //    methods.showmodal(data);
                  //   }, 20);
              }
              else{
                  var updateable = $(settings.orig).find('.updateable');
                  if(updateable.length == 0) {
                    updateable = $(settings.orig)
                  }
                  updateable.html(data);
                  $.modal.close();                                
              }
          },
          error:function(data,textStatus) {
              say('error');
          }	
      });
    },
    
    show : function(dialog) {
        
        if(false){
        //if(settings.callback){
          say('callback');
          var params = { param1:'hello', param2:'goodbye'};
          settings.callback(params);
        }
    
        settings.dialog = dialog;
        
        dialog.container.css("height", "auto");
        dialog.container.css("width", "auto");
//        $('.simplemodal-submit').bind('submit.simplemodal', function (e) {
//          e.preventDefault();
//          methods.post(dialog);
//        });

 //       $('.simplemodal-submit').validate();
    
        //$(dialog.data).live('submit', function () {
        //$(dialog.data).bind('submit.editable', methods.post(dialog) );

        $(dialog.container, "form").bind('submit', function () {
            methods.post(dialog);
            return false;
        });
    },
    
    showmodal : function( item ) {
      $(item).modal({
          position: [options.pos.top-$(window).scrollTop(), options.pos.left],
          onShow: methods.show
      });	    
    }
  };
  
  var settings = {
    url: '',
    controller: ''
  };

  $.fn.editable = function(method) {

    if ( methods[method] ) {
      return methods[method].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.editable' );
    }              
  };
  
})(jQuery);


(function($){

    $.fn.newscomment = function(customOptions) {
        // support mutltiple elements
        if (this.length > 1){
            this.each(function() { $(this).newscomment(customOptions) });
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
            url : '',                        
            status : '',                        
            debug : false
        };

        var options = $.extend({}, defaultOptions, customOptions);
        
        // SETUP private functions;
        var intialize = function() {            
            $(base).find('.comment-toggle').click(function() {
//              console.log("%s: %o", 'newsfeed focus out', base);
              show();
              return false;
            });
            options.url = base.attr('url');
            options.status = base.attr('status');
            return base;
        };
       
        var showComment = function() {
//          console.log("%s: %o", 'show comment', base);
          
          var feed = $(base).find('.feed-comments');
          
          if(feed.size()==0){
            feed = $("<div>")
            .addClass('feed-comments')
            .appendTo(base);
          }
          loadComment(feed);
        };
        
        var loadComment = function(feed) {
          jQuery.ajax({
              url: options.url,
              type: "GET",
              data: {status: options.status},
              complete:function(data,textStatus) {
//                  console.log("%s: %o", 'post complete', base);                  
              },
              success:function(data, textStatus, xhr) {
//                  console.log("%s: %o", 'post success', base);
                  $(data).appendTo(feed);
                  
                  $(base).find('#updateStatusForm').submit(function() {
//                    console.log("%s: %o", 'comment submit', base);
                    postComment(this);
                    return false;
                  });
                  
                  $(base).find('#cancelComment').click(function() {
//                    console.log("%s: %o", 'comment submit', base);
                    removeComment();
                    return false;
                  });
                  
                  
              },
              error:function(data,textStatus) {
//                  console.log("%s: %o", 'post error', base);
              }	
          });
        }
        
        var postComment = function(form){
          jQuery.ajax({
            url: options.url + '/' + options.status,
            type:'POST',
            data:$(form).serialize(), 
            success:function(data,textStatus){
              $(base).find('.feed-comments').replaceWith(data);
              //$('#messages').html(data);
            },
            error:function(XMLHttpRequest,textStatus,errorThrown){}
          });
          return false;
        }
        
        var removeComment = function() {
          var comments = $(base).find('.comment.clearfix');
          if(comments.size()>1){
            $(base).find('.comment.clearfix.new').remove();
          }
          else{
            $(base).find('.comment.clearfix.new').remove();
            $(base).find('.feed-comments').remove();
          }
        };
        
        var show = function() {
          var comment = $(base).find('.comment.clearfix.new');
          if(comment.size()>0){
            removeComment();            
          }
          else {
            showComment();
          }
        };
        
        // PUBLIC functions
        this.changeTab = function() {
            // change Tab
        };

        return intialize();
    }

})(jQuery);


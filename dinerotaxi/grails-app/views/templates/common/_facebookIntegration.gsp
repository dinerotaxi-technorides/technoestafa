<script type="text/javascript">
	window.fbAsyncInit = function() {
        FB.init({ appId: '${ facebookContext.app.id}',
	        status: true,
	        cookie: true,
	        xfbml: true,
	        oauth: true
        });

    	//Like button events for traderprogressbar
   		FB.Event.subscribe('edge.create',
  		    function(response) {
   				//alert("You Liked: " + response);
   				if(response=="https://www.facebook.com/apps/application.php?id=${ facebookContext.app.id}"){
   					updateLikeItem(true);
   					$("#trader_progress").find("#like_link").removeClass("checked").removeClass("like").addClass("checked");
   					setTraderProgressValue(getTraderProgressValue()+(100/getTraderProgressItemCount()));   	   		    	
   	   		    }
   		    }
  		);
      	FB.Event.subscribe('edge.remove',
   		    function(response) {
   		    	//alert("You Disliked: " + response);
   		    	if(response=="https://www.facebook.com/apps/application.php?id=${ facebookContext.app.id}"){
   		    		updateLikeItem(false);
   		    		$("#trader_progress").find("#like_link").removeClass("checked").removeClass("like").addClass("like");
   		    		setTraderProgressValue(getTraderProgressValue()-(100/getTraderProgressItemCount()));    	
   	   		    }
   		    }
     	);

      	FB.Canvas.setAutoGrow(true);
      	
    	var last_height = 0;
    	setInterval(function() {
    		var height = $('html').height();
    		if (height!=last_height){
    		    FB.Canvas.setSize({height:height});
    		    last_height=height;
    		}
    	}, 500);
    	
	};
	(function() {
	    var e = document.createElement('script'); e.async = true;
	    e.src = document.location.protocol
	        + '//connect.facebook.net/en_US/all.js';
	    document.getElementById('fb-root').appendChild(e);
	}());
</script>
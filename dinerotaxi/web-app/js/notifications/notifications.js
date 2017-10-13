var notifications;
$(function() {

     notifications = new $.ttwNotificationMenu({
        notificationList:{
            anchor:'item',
            offset:'0 15'
        }
        
    });

    notifications.initMenu({
        notifications:'#notifications'
    });
    
 	waitForMsg(); /* Start the inital request */

});

function addmsg(notificationMessage){

    notifications.createNotification({ message:notificationMessage.message,idMessage:notificationMessage.id, category:'notifications' });
    
}

function waitForMsg(){
    /* This requests the url "msgsrv.php"
    When it complete (or errors)*/
    $.ajax({
        type: "GET",
        url: contextPath+"notificationApi/getAllNotificationsNotReader",
        async: true, /* If set to non-async, browser shows page as "Loading.."*/
        cache: false,
        timeout:50000, /* Timeout in ms */

        success: function(data){ /* called when request to barge.php completes */
        	
        	if(data.status==100 && data.notifications!=null && !isVisible){
        			var as=window.notifications.getNotifications("notifications","unread");
	        		for(var i in as){
	        			window.notifications.deleteNotification(window.notifications.getNotifications("notifications","unread")[i]);
	        		}
		    		document.getElementById('notifications').childNodes[2].innerHTML=0;
		    		window.notifications.notifications.notifications.count=0;
		    		window.notifications.notifications.notifications.unreadCount=0;
        		
        		   for(var i=0;i<data.notifications.length;i++){
        		   		addmsg(data.notifications[i]); /* Add response to a .msg div (with the "new" class)*/
        		   }
        	}
        	
            setTimeout(
                waitForMsg, /* Request next message */
                3000 /* ..after 1 seconds */
            );
        },
        error: function(XMLHttpRequest, textStatus, errorThrown){
            addmsg("error", textStatus + " (" + errorThrown + ")");
            setTimeout(
                waitForMsg, /* Try again after.. */
                15000); /* milliseconds (15seconds) */
        }
    });
};


		 

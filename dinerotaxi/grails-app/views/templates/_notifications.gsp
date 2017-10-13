<style>
<%--	.stream .ui-selecting { background: #DFDDDD; }--%>
<%--	.stream .ui-selected { background: #DFDDDD; color: black; }--%>
	.stream {padding-left:10px;}
</style>

<div class="header-newsfeed">
	<span class="left">Notifications</span>
	<span class="right">
	<g:if test="${isFacebook()=='true'}">
		<a id="prev" style="cursor:pointer; display:none" onclick="prevPage()">Previous</a>
		<a id="next" style="cursor:pointer;" onclick="nextPage()">Next</a>
	</g:if>
	</span>
</div> 
<div id="newsfeed"> 
    <ul class="stream span-${(isFacebook()=='true')?'10':'13'} first">
	    <g:render template="notificationDetail" model="${[notifications:notifications.feeds]}"></g:render>  
    </ul>
    <div style="position:fixed; width:100%;left:0px;">
	    <div style="position:relative; width:1000px; margin:0 auto;">
		    <div class="stream-item-details span-${isFacebook()=='true'?'9':'12'} last" style="position:relative; left:${isFacebook()=='true'?'395px':'524px'}; display:none; max-height: 750px; overflow:hidden;">
		    	<div class="notifications-close">close <a class="hide" onclick="$('.stream-item-details').hide('slide',function(){$('.dashboard-content').removeClass('faded');}); " title="Close Notification View">&times;</a></div>
		    	<div id ="stream-details" style="max-height: 750px; overflow-y: auto;">Content</div>
		    </div>
	    </div>
    </div>
    
    <!-- Dashboard Starts -->       
    <div class="dashboard span-${isFacebook()=='true'?'8':'11'} last">
      <div class="dashboard-content">

      <div id="last_trade"></div>
	<span class="sp"></span>
	<div class="clearfix">
      <div id="today_trends" class="span-${isFacebook()=='true'?'4':'6'}"></div>   
	  <div id="monthly_trends" class="span-${isFacebook()=='true'?'3':'4'}"></div>
	</div>
	<span class="sp"></span>      
      <div id="friends"></div>
	<span class="sp"></span>      
      <div id="top_traders"></div>
	<span class="sp"></span>      
   	<div class="clearfix">
	  <h3>Download <span class="green">Tradefields</span></h3>      
	  <h6><a href="${message(code:'links.ipad')}" target="_blank">Tradefields for iPod, iPhone &amp; iPad</a></h6>
      <p>Download the official Tradefields app for Apple mobile devices</p>
	  <h6><a href="${message(code:'links.blackberry')}" target="_blank">Tradefields for BlackBerry</a></h6>
      <p>Download the official Tradefields app for BlackBerry</p>
	  <h6><a href="${message(code:'links.android')}" target="_blank">Tradefields for Android</a></h6>
      <p>Download the official Tradefields app for Android mobile devices</p>
	</div>      
	</div>
    </div>
    <div style="clear:both"></div>   
</div>
<script type="text/javascript">
	loadRightSide(${highlight?:0});
</script>

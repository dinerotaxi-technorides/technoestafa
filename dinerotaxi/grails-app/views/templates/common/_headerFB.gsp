<div>
	<hr class="space"/>
	<div id="headercountdown1">
		<g:link  params="[country:"${params?.country?:''}"]"  url="${createLink(controller:'facebook', action:'index')}" class="logo left" title="TradeFields Stock Market Simulator"></g:link>
		<div class="right" id="countdown"></div>
	</div>
	<hr class="space"/>
      <div class="topbar">
        <div class="left"> 
        	<span><a href="${application.getContextPath()}/fb/profile"><img class="user-pic" src="https://graph.facebook.com/${user.uid}/picture" align="absmiddle" class="user-pic" alt="${(user?.name)?:''}" alt="${session.facebookName}" onerror="src='${resource(dir:'img/profiles',file:'fb_pic.jpg')}'"/></a></span> 
<%--			<span class="vr"></span>--%>
			<g:if test="${user?.feed_count>0}">
				<span class="notifications active' title="Notifications" onclick="location.href='${application.getContextPath()}/fb/notifications'"><a style="text-decoration: none;">${user?.feed_count!=null?user?.feed_count:0}</a></span>
			</g:if>
        	   	<span class="vr"></span> 
            	<span id="invite"><a class="btn_invite" onclick='inviteFriends("${user.accessToken}", "iframe", function(){}, "${g.message(code:'common.invite.message')}");' title="Invite Friends">Invite Friends</a></span> 
        </div>
        <div class="right"> 
        	<span class="vr"></span> 
            <span id="search">
		            <form id="quickSearchField" action="">
		            <input type="text" id="search-query" autocomplete="off" name="search-query" maxlength="20" size="18"/>
	            </form>
				<script type="text/javascript">var suggestr = new ajaxSuggestFbml(document.getElementById('search-query'),options,'${application.getContextPath()}');</script>
            </span>
          	<span class="vr"></span> 
          	<span id="trade">
          	<a href="#" onclick="showTradeBox($('#search-query').val());" class="btn_trade" title="<g:message code="head.trade"/>"></a></span>
          	<span class="vr"></span> 
          	<span id="find"><a title="<g:message code="symbol.browse"/>" class="btn_find"></a></span>
         </div>
      </div>
	<div id="trends" style="overflow:hidden;">
		<div id="contentbody"></div>
	</div>
</div>      

<script type="text/javascript">
	${remoteFunction(controller:'common', action:'trendingBarFB',update:'contentbody',onSuccess:'$("#trends-ticker").newsticker(5000);')}
</script>

<g:if test="${user}">
	<script type="text/javascript">
		new marketCountdown("countdown"); 
		initHeader();
	</script>
</g:if>
<div id="headerBar">
    <div class="inner clearfix">
        <g:link  params="[country:"${params?.country?:''}"]" url="${createLink(controller:'index', action:'index')}" class="logo left" title="TradeFields Stock Market Simulator"></g:link>
        <div class="left"> 	
            <span class="vr"></span>           
        </div>
        <div class="right">
        <g:isFacebookLoggedIn>
            <span id="welcome" style="display: inline-block; "><g:message code='guestheader.hello'/> <fb:name uid="loggedinuser" useyou="false"><a class="fb_link" href="https://www.facebook.com/profile.php?id=${session.facebookId?:'1116618306'}">${session.facebookName}</a></fb:name></span>
        </g:isFacebookLoggedIn>
        <g:isFacebookNotLoggedIn>
            <span id="welcome" style="display: inline-block; "><g:message code='guestheader.hellostranger'/></span>
        </g:isFacebookNotLoggedIn>        
            <span class="vr"></span> 
            <div>
	            <g:form controller="ssconnect" action="facebook" name="loginFormFacebook" style="margin-top: 5px;margin-bottom: 5px;" >            
<%--				    <input type="hidden" name="scope" value="user_about_me,read_friendlists">--%>
					<input type="hidden" name="scope" value="email"/>
					<span onclick="socialLogin('Facebook')" class="fb-connect"></span>
	            </g:form>
			</div>
            <span class="vr"></span>
            <span id="search">
	            <form id="quickSearchField" action="">
		            <input type="text" id="search-query" autocomplete="off" name="search-query" maxlength="20" size="22"/>
		            <a href="#" class="ico_geo"></a>
	            </form>
				<script type="text/javascript">var suggestr = new ajaxSuggestFbml(document.getElementById('search-query'),options,'${application.getContextPath()}');</script>
            </span>
            
            <span id="find"><a title="<g:message code="symbol.browse"/>" class="btn_find"></a></span><span class="vr"></span>
        </div> 
    </div> 
</div>
	
<div id="trendingBar" style="overflow:hidden;">
		<div class="inner">
			<div id="contentbody" class="span-16"></div>
			<div id="news-top-bar"class="span-8"></div>
		</div>	
</div>

<div class="container span-25">
<hr class="space">
<div class="alert-message success" id="messageSuccess" style="display: none;">
	<a href="#" class="close"  onclick="$('#messageSuccess').fadeOut();">&times;</a>
	<div id="messageSuccessContent"></div>
</div>
<div class="alert-message error" id="messageError" style="display: none;" >
	<a href="#" class="close" onclick="$('#messageError').fadeOut();">&times;</a>
	<div id="messageErrorContent"></div>
</div>

</div>


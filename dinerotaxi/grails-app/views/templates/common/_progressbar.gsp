<div id="trader_progress" class="box" style='display:none;'>
			<strong>${session.facebookName.split(" ")[0].capitalize() }</strong>, completing your profile is so simple, just:
			<hr class="space"/>
		<div id='trader_progress_bar'>
		</div>	
		<!-- class="div_progress ui-progressbar ui-widget ui-widget-content ui-corner-all"
			role="progressbar" aria-valuemin="0" aria-valuemax="100"
			aria-valuenow="0">
			<div class="ui-progressbar-value ui-widget-header ui-corner-left">
				<span id='trader_progress_percent'>0</span> % Complete
			</div> -->
		<ul class="checklist">
			<li class="checked"><g:message code='progressbar.appinstalled'/></li>
			<li id="bookmark_link" style="display: none;"><a title="Bookmark" class="bookmark" href=""><g:message code='progressbar.bookmark'/></a></li>
			<li id="bookmark_linked" class="checked"><g:message code='progressbar.bookmarked'/></li>			
			<li style="" class="like" id="like_link">		
				<fb:like href="https://www.facebook.com/apps/application.php?id=${ grailsApplication.config.grails.plugins.springsecurity.facebook.appId}" layout="button_count" send="false" layout="button_count" width="60" show_faces="false" font="verdana"></fb:like>
			</li>			
			</li>
			<!--<li id="suscribe_link" class="suscribe" style="display: none;"><a
				onclick="fbLoginWithCustomPermissions('email');" title="Suscribe">Suscribe</a>
			</li>
			<li id="suscribe_linked" class="checked" style="display: block;">Suscribed</li>-->
			<li id="permissions_link" class="permissions" style="display: none;">
<%--			<a	onclick="fbLoginWithCustomPermissions('publish_stream');" title="Permissions">Permissions</a>--%>
			<a	id="fbLoginWithCustomPermissions" onclick="fbLoginWithCustomPermissions('publish_stream');" title="Permissions"><g:message code='progressbar.permissions'/></a>
			</li>
			<li id="permissions_linked" class="checked" style="display: block;"><g:message code='progressbar.permissions'/></li>
<%--			TWITTER INTEGRATION DISABLED--%>
<%--			<li id="twitter_link" class="twitter" style="display: none;"><a data-service="twitter" onclick="showTwitterWindow();">Connect My Twitter</a></li>--%>
<%--			<li id="twitter_linked" class="checked">Twitter Connected</li>       --%>
		</ul>
	</div>
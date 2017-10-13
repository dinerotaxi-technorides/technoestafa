<div id="headerBar">
	<div class="inner clearfix">
		<g:link  params="[country:"${params?.country?:''}"]" url="${createLink(controller:'index', action:'index')}" class="logo left"
			title="TradeFields Stock Market Simulator"></g:link>
		<div class="left">
			<span class="vr"></span>
			<g:if test="${!error}">
				<span id="balance"><span class="positive"><g:number
							format="###,###" dollar="true"
							value="${(user?.balance)?user.balance:(session.temporalbalance?:'0')}" />
				</span><a title="<g:message code='head.gotoportfolio'/>"
					href="${application.getContextPath()}/portfolio"
					class="btn_portfolio" style="margin-left: 16px"><g:message
							code="head.portfolio" />
				</a>
				</span>
			</g:if>
			<g:else>
				<span id="balance"><span class="positive"><g:message
							code="error.problem_ocurred" />
				</span><a title="<g:message code='head.gotoportfolio'/>"
					href="${application.getContextPath()}/portfolio"
					class="btn_portfolio"><g:message code="head.portfolio" />
				</a>
				</span>
			</g:else>
			<span class="vr"></span> <span id="rankings"><a
				title="<g:message code="head.view_full_rankings"/>"
				href="${application.getContextPath()}/ranking" class="btn_rankings"><g:message
						code="head.rankings" />
			</a>
			</span>
			<%--            <span class="vr"></span>--%>
			<%--            <span><a title="<g:message code="head.need_help"/>" href="${application.getContextPath()}/help" class="btn_help"><g:message code="head.help"/></a></span>--%>
		</div>
		<div class="right">
			<span class="vr"></span> <span id="search">
				<form id="quickSearchField" action="" />
				<input type="text" id="search-query" autocomplete="off"
				name="search-query" maxlength="20" size="22" /><a href="#"
				class="ico_geo"></a>
			</form> <script type="text/javascript">var suggestr = new ajaxSuggestFbml(document.getElementById('search-query'),options,'${application.getContextPath()}');</script>

			</span> <span class="vr"></span> <span id="trade"><a href="#"
				onclick="showTradeBox($('#search-query').val());" class="btn_trade"
				title="<g:message code="head.trade"/>"></a>
			</span><span class="vr"></span> <span id="find"><a
				title="<g:message code="symbol.browse"/>" class="btn_find"></a>
			</span><span class="vr"></span> <span><span
				class="${user?.feed_count>0?'notifications active':'notifications'}"
				title="Notifications"
				onclick="location.href='${application.getContextPath()}/notifications?highlight=${user?.feed_count!=null?user?.feed_count:0}'"><a
					style="text-decoration: none;">
						${user?.feed_count!=null?user?.feed_count:0}
				</a>
			</span>
			</span> <span class="vr"></span> <span id="user-active"><a
				class="user-login"><img class="user-pic"
					src="https://graph.facebook.com/${session.facebookId}/picture"
					align="absmiddle" class="user-pic" title="${(user?.name)?:''}"
					alt="${session.facebookName}"
					onerror="src='${resource(dir:'img/profiles',file:'fb_pic.jpg')}'" />
			</a> <g:render template="/templates/common/dropdownMenu" /> </span> <span
				class="vr"></span>

		</div>
	</div>
</div>

<div id="trendingBar" style="overflow: hidden;">
	<div class="inner">
		<div id="contentbody" class="span-16"></div>
		<div id="news-top-bar" class="span-8"></div>
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

<script type="text/javascript">
	initHeader();
</script>


<hr id="navDot" class="dot"/>
<div class="navigation clearfix">
       <div class="span-3">
           <li><g:message code="common.company"/><ul>
               <li><g:link  params="[country:"${params?.country?:''}"]" controller="about"><g:message code="common.about"/></g:link></li>
               <li><g:link  params="[country:"${params?.country?:''}"]" controller="contact"><g:message code="common.contact"/></g:link></li>
               <li><g:link  params="[country:"${params?.country?:''}"]" controller="press"><g:message code="common.press"/></g:link></li>
               <li><g:link  params="[country:"${params?.country?:''}"]" controller="media"><g:message code="common.media_kit"/></g:link></li>
               </ul>
           </li>
       </div>
       
       <g:isFacebookLoggedIn>
	       <div class="span-3">        
	           <li><g:message code="common.my_profile"/><ul>
	               <li><a href="${application.getContextPath()}/watchlist"><g:message code="common.watchlists"/></a></li>
	               <li><a href="${application.getContextPath()}/notifications"><g:message code="common.notifications"/></a></li>
	               <li><a href="${application.getContextPath()}/settings"><g:message code="common.settings"/></a></li>
	               <li><a href="${application.getContextPath()}/download"><g:message code="common.download"/></a></li>            
	               </ul>
	           </li>                                   
	       </div>   
       </g:isFacebookLoggedIn>       
       <div class="span-3">
           <li><g:message code="common.download"/><ul>
               <li><a href="${message(code:'links.ipad')}" target="_blank"><g:message code="common.ipad"/></a></li>
               <li><a href="${message(code:'links.iphone')}" target="_blank"><g:message code="common.iphone"/> &amp; <g:message code="common.ipod"/></a></li>
               <li><a href="${message(code:'links.android')}" target="_blank"><g:message code="common.android"/></a></li>   
               <li><a href="${message(code:'links.blackberry')}" target="_blank"><g:message code="common.blackberry"/></a></li>        
               </ul>
           </li>
       </div>  
<%--       <div class="span-3">--%>
<%--           	<ul>        --%>
<%--	           	<li><g:message code="common.get_involved"/>--%>
<%--				<li><a href="/tradefields_sandbox/index/api"><g:message code="common.api"/></a></li>                   --%>
<%--				<li><a href="/tradefields_sandbox/company/jobs"><g:message code="common.jobs"/></a></li>--%>
<%--				<li><a href="/tradefields_sandbox/company/advertise"><g:message code="common.advertise"/></a></li>  --%>
<%--				<li><a href="/tradefields_sandbox/index/partnerships">Partner with Us</a></li>--%>
<%--				<li><a href="/tradefields_sandbox/index/goodies">Goodies & Plugins</a></li>   --%>
<%--				<li><a href="/tradefields_sandbox/index/labs">Tradefields Labs</a></li>--%>
<%--			</ul>--%>
<%--		</div>    --%>
<div class="span-3">
    <li><g:message code="common.connect"/><ul>
        <li><a href="https://www.facebook.com/tradefields" target="_blank"><g:message code="common.facebook"/></a></li>    
        <li><a href="https://twitter.com/tradefields" target="_blank"><g:message code="common.twitter"/></a></li>
        <li><a href="#" onclick="inviteFriends('${session.accessToken}', 'iframe', function(response){
			if (response && response.request_ids) {
			 	var inviteCount = (response.request_ids).toString().split(',').length;
			 	var message;
			 	if (inviteCount==1){
			 		message='<p><strong>Congrats!</strong> Thank you for invite your friend</p>';
			 	}else if (inviteCount>1){
			 		message='<p><strong>Congrats!</strong> Thank you for invite ' + inviteCount + ' friends</p>';
			 	}
				showSuccessMessage(message);
	        }}, '${g.message(code:'common.invite.message')}');"><g:message code="common.invite_friends"/></a></li>                 
        </ul>
    </li>
</div>   
<%--<div class="span-3">--%>
<%--    <li>Legal<ul>--%>
<%--        <li><a href="/tradefields_sandbox/help/terms">Terms of Use</a></li>--%>
<%--        <li><a href="/tradefields_sandbox/help/privacy">Privacy Policy</a></li>--%>
<%--        <li><a href="/tradefields_sandbox/help/disclaimer">Copyright Policy</a></li>--%>
<%--        </ul>--%>
<%--    </li>--%>
<%--</div>   --%>
<div class="span-3">
    <li><g:message code="common.get_help"/><ul>     
        <li><a href="${application.getContextPath()}/help"><g:message code="common.faq"/></a></li>
        <li><a href="${application.getContextPath()}/support"><g:message code="common.support"/></a></li>
<%--        <li><a href="http://www.tradefields.com/wiki/" target="_blank"><g:message code="common.wiki"/></a></li>               --%>
        <!--<li><a href="/tradefields_sandbox/index/tips">Tips</a></li>-->    
               </ul>
           </li>   
       </div>   
</div>

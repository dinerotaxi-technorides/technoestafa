<section id="profilewall" class="${(isFacebook()=='true')?'span-12':'clarfix'}">
       <div class="wall ${(isFacebook()=='true')?'span-12':'clearfix' }">
       <g:isFacebookLoggedIn>
	       <g:render template="/wall/tpl/wallpostShareBox" model="${[userToPost:userToPost]}"></g:render>
       </g:isFacebookLoggedIn>
       </div>
       
       <div id="wallPostsDiv" ${isFacebook()=='true'?'class=\"span-12\"':''}>
       		<g:render template="/wall/tpl/wallposts" model="${[userToPost:userToPost]}"></g:render>
       </div>              
       <div id='WPLoadMoreStatusDiv'></div>
</section>

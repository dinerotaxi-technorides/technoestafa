<section id="supportwall" class="clearfix">
       <div class="wall clearfix">
       <g:isFacebookLoggedIn>
	       <g:render template="/templates/wall/wallpostShareBox" model="${[userToPost:userToPost]}"></g:render>
       </g:isFacebookLoggedIn>
       </div>
       
       <div id="wallPostsDiv">
       		<g:render template="/templates/wall/wallposts" model="${[userToPost:userToPost]}"></g:render>
       </div>               
       <div id='WPLoadMoreStatusDiv'></div>
</section>

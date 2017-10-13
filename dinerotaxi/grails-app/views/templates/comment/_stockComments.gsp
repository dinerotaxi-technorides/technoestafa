<section id="stockcomments" ${(isFacebook()=='true')?"class=\'clearfix span-12\'":"" }>
       <div class="wall clearfix">
       <g:isFacebookLoggedIn>
	       <g:render template="/templates/comment/commentShareBox" model="${[quoteToPost:quoteToPost]}"></g:render>
       </g:isFacebookLoggedIn>
       </div>
       
       <div id="commentsDiv">
       		<g:render template="/templates/comment/comments" model="${[quoteToPost:quoteToPost]}"></g:render>
       </div>              
       <div id='CommentLoadMoreStatusDiv'></div>
</section>
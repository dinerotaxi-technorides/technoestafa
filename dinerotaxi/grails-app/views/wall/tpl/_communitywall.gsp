<section id="communitywall" class="clearfix">

       <div class="wall clearfix">
       <g:isFacebookLoggedIn>
	       <g:render template="/wall/tpl/wallpostShareBox" model="${[userToPost:userToPost]}"></g:render>
       </g:isFacebookLoggedIn>
       </div>
       
       <div id="wallPostsDiv">
       		<g:render template="/wall/tpl/wallposts" model="${[userToPost:userToPost]}"></g:render>
       </div>              
       <div id='WPLoadMoreStatusDiv'></div>
</section>
<script type="text/javascript">
/*
$(document).ready(function() {
    $(window).scroll(function() { 
        if ($('body').height() <= ($(window).height() + $(window).scrollTop())) {
			$("#load-more-wallposts").click();
        }
    });
});
*/  
</script>

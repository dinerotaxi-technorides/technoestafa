<div id="header">
	<div class="topbar">
		<div class="left">
			<span class="vr"><a href="#" class="logo left"><img
					src="${createLinkTo(dir:'img',file:'logo1.png')}" alt="Freddo.com">
			</a> </span>  <span class="vr"></span> <span class="vr"></span> <span id="gain"><span
				class="negative"></span> <span class="vr"></span> <span class="vr"></span>
				<!-- span class="vr"></span> <span id="invite"><a
					class="btn_invite" title="Invite Friends">Invite Friends</a>
			</span -->
			<span id="invite"><a class="btn_invite"  href="${createLink(controller:'invite', action:'index')}">Invitar Amigos</a></span> 
		</div>
		<div class="right">
			<span><a href="/Freddo/profile"><img class="user-pic"
					src="https://graph.facebook.com/${fbuser.uid}/picture"
					align="absmiddle" class="user-pic" title="${(user?.name)?:''}"
					alt="${session.facebookName}"
					onerror="src='${resource(dir:'img/profiles',file:'fb_pic.jpg')}'" />
			</a> </span>
		</div>
	</div>
</div>

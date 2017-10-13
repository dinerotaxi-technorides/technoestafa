
<div id="header-wrapper">
		<header>
				<h1>
						<a href="">DineroTaxi.com</a>
				</h1>
				<nav id="main">
						<ul>
								<li class="${request.getServletPath().contains("home")?'active':''}"><g:link  params="[country:"${params?.country?:''}"]" controller="home" >Dashboard</g:link>
								</li>
								<li class="${request.getServletPath().contains("pedir")?'active':''}"><g:link  params="[country:"${params?.country?:''}"]" controller="pedir" >Pedir Taxi</g:link>
								</li>
								<li class="${request.getServletPath().contains("favoritos")?'active':''}"><g:link  params="[country:"${params?.country?:''}"]" controller="favoritos" >Favoritos</g:link>
								</li>
						</ul>
				</nav>
				<sec:ifAllGranted roles="ROLE_USER">	
				
				<nav id="session">
					<ul>
						<li>
							<a href=""><sec:username /></a>
							<ul>
								<li class="company-profile"><a href=""><sec:username /></a></li>
								<li class="settings"><a href="settings.html">Account Settings</a></li>
								<li class="logout"><g:link  params="[country:"${params?.country?:''}"]" controller="logout">Logout</g:link></li>
							</ul>
						</li>
					</ul>
				</nav>
				</sec:ifAllGranted>

		</header>
</div>


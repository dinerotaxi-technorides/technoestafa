	<!-- LOGIN -->

				<div class="bOX725 mt10">

					<h1>¿Usuario de DINEROTAXI?</h1>

					<form action="${request.contextPath}/j_spring_security_check"
					method='POST' id='userLoginInBodyForm' name="userLoginInBodyForm"
					 autocomplete='on' class="ml20">

						<div class="blockInputMin_">
							<span class="flMin">Email</span> <input id="username" type="text"
								name='j_username' placeholder="pepe@hotmail.com"
								class="inputShortMin" />
						</div>


						<div class="blockInputMin">
							<span class="flMin">Contraseña</span> <input id="password"
								type="password" name="j_password" placeholder="**********"
								class="inputShortMin" />
						</div>
					<input type="submit" class="entrar" value=""/>
					<div class="olvido">
						<a href='<g:createLink params="[country:"${params?.country?:''}"]"  controller="register" action="forgotPassword"/>' class="">¿olvido su contraseña?</a>
						&nbsp;&nbsp;
						
					</div>


					</form>

					
					<br />

					<div class="blockInput_">
<%--						<span class="fb-connect" onclick="loginFacebookUser();" style="visibility: visible;"></span>--%>
<%--		 			--%>
<%--						 <span class="ml5">¿Ya tenés una cuenta en--%>
<%--							Facebook? Usala para registrarte en DineroTaxi!</span>--%>
					</div>

				</div>

				<!-- END LOGIN -->
				<div class="bOX725 mt20">

					<h1>Nuevo Usuario</h1>


					<g:form action="registerUsr" controller="register" name="registrationForm" id="registrationForm">
						<div class="blockInput_"> 
							 <label class="fl" for="firstName">Nombre*</label> 
                 		 <div class="encierra_input"><input id="firstName" type="text"
								name="firstName" placeholder="requerido " size="34" value="${command?.firstName}" /></div>
						</div>

						<div class="blockInput_">
							<label class="fl" for="lastname">Apellido*</label> 
                     <div class="encierra_input"><input id="lastName" type="text"
								name="lastName" placeholder="requerido" size="34" value="${command?.lastName}"/></div>
						</div>

						<div class="clearFix"><br /></div>

						<div class="blockInput_">
							 <label class="fl" for="email">Email*</label> 
                       <div class="encierra_input">
                       <input id="email" type="text" name="email" placeholder="ejemplo@mail.com" size="34" value="" />
                       </div>
						</div>
						<div id=”emailInfo” align=”left”></div>
						<div class="blockInput_">
								<label class="fl" for="phone">Teléfono*</label> 
                         <div class="encierra_input"> <input id="phone" type="text" name="phone" placeholder="requerido" size="34" value=""/></div>
						</div>


						<div class="clearFix"><br /></div>

					
						<div class="blockInput_">
							<label class="fl" for="password">Contraseña*</label> 
                     <div class="encierra_input"><input id="password1" type="password" name="password" placeholder="contraseña" size="34" /></div>
						</div>

						<div class="blockInput_">
							<label class="fl" for="password2">Repetir contraseña*</label> 
                                                      	
                      <div class="encierra_input"><input id="password2" type="password" name="password2" placeholder="confirmar contraseña" size="34" /></div>
						</div>

						<div class="clearFix"><br /><br /></div>


						<div class="blockInput_ ml90 mt10" >
							<label class="label_checkHome fixIe" for="agree">
                                                        	<a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="termsAndConditions" />" target="_blank"
								class="linkDocs">Acepto los términos y condiciones</a>
                                                        </label>       
                                                            <input name="agree" id="agree" value="1" type="checkbox"  />

							<div class="clearFix mt10"></div>
							<label class="label_checkHome fixIe" for="politics">
                     <a href="<g:createLink params="[country:"${params?.country?:''}"]"  controller="index" action="termsAndConditions" />" target="_blank" class="linkDocs">Acepto las políticas de privacidad</a> </label>   
                       <input
								name="politics" id="politics" value="1"
								type="checkbox" /> 
							<div class="clearFix"></div>
							<div class="itemL txtImportante">(*)Campos obligatorios.</div>
					
</div>

						<div class="blockInput_ mt10 ml90">
							<img src="${resource(dir:'images',file:'eConfianza.png')}" alt="eConfianza.org"
								title="eConfianza.org" />
						</div>

						<div class="clearFix">
							<br />
							<br />
						</div>

						 <input type="submit" name="submit" value="" class="registrate">
						<%--<a class="registrate" href="#dialog" name="modal"></a>

					--%></g:form>

				</div>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>


<!--METATAGS-->    
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="DC.title" content="DineroTaxi.com | La nueva forma de tomar un taxi!" />
<meta name="DC.creator" content="Carlos Matías Baglieri" />
<meta name="DC.description" content="La nueva forma de tomar un taxi" />
<meta name="DC.type" scheme="DCTERMS.DCMIType" content="Text" />
<meta name="DC.format" content="text/html; charset=UTF-8" />
<meta name="DC.identifier" scheme="DCTERMS.URI" content="https://www.dinerotaxi.com" />
<meta http-equiv="content-language" content="es" />
<meta name="Language" content="Spanish, Español"/>
<meta name="Geography" content="capital Federal, Buenos Aires, Argentina"/>
<meta name="distribution" content="Global"/>
<meta name="robots" content="nofollow"/>
<meta name="country" content="Argentina"/>
<meta name="Classification" content="services"/>
<meta name="generator" content="Bluefish 2.0.2" />
<meta name="Keywords" content="taxi|transporte|dinero|viajes"/>
<meta name="copyright" content="https://www.dinerotaxi.com" />
<meta http-equiv="Expires" content="never"/>
<meta name="Subject" content="DINERO TAXI"/>
<meta name="layout" content="dinerotaxi"/>
<script  type="text/javascript" src="${resource(dir:'js',file:'funciones1.js')}"></script>
</head>
<body>
	
<div class="mainContent">

	<div class="con">
    
    	<div class="container">
    	
		   <g:if test="${flash.message}">
            	<div class="success" on>${flash.message}</div>
				<script type="text/javascript">
					showSuccessMessage();
				</script>
            </g:if>
            <g:if test="${flash.error}">
            	<div class="errors">${flash.error}</div>
				<script type="text/javascript">
					showErrorMessage();
				</script>
            </g:if>
                
         <div class="bOX725 mt20">
        
                <h1>Ingrese sus datos para que podamos reactivar su cuenta</h1>       
                
               <g:form action="savePhone" controller="register" name="contactForm">
            
                <div class="blockInput_">
                	<label class="fl" for="firstName">Nombre*</label>
                	<div class="encierra_input">  <input id="firstName" type="text" name="firstName" placeholder="ej:Nombre" value="${user?.firstName}" size="34" /></div>
                </div>
                
                <div class="blockInput_">
                	<label class="fl" for="lastName">Apellido*</label>  
                	<div class="encierra_input"><input id="lastName" type="text" name="lastName" value="${user?.lastName}" placeholder="ej: Apellido" size="34" /></div>
               	</div>
                <div class="blockInput_"><label class="fl" for="email">Email</label> 
	                <g:if test="${user?.email}"> 
	                	<div class="encierra_input"><input id="email" type="text" name="email" value="${user?.email}" placeholder="ej:ejemplo@mail.com" size="34" style="color:black" readonly/></div>
	                  </g:if>
	                  <g:else>
	                 	 <div class="encierra_input"><input id="email" type="text" name="email" placeholder="ej:ejemplo@mail.com" size="34" style="color:black" /></div>
	                  </g:else>
                </div>
                
                <div class="blockInput_"><label class="fl" for="phone">Teléfono*</label> 
                	<div class="encierra_input"> <input id="phone" type="text" name="phone"  value="${user?.phone}" placeholder="ej:1533334444" size="34" /></div>
                </div>
               
                
                <div class="blockInput_ ml90">
                                       
                    <div class="itemL txtImportante">(*)Campos obligatorios.</div>    
                </div>
                
                
                <div class="clearFix"></div>
                
				<input type="submit" name="submit" value="" class="enviar">
                
                </g:form>
            
        	</div>
            
        </div> 
        
        <!-- SIDEBAR -->
        
        <div class="sidebar mt10">
            
              
			<!--  g:render template="/template/recomenda" /-->
                
                
			<g:render template="/template/shareFacebook" />
            
            </div>
            
            <!-- END SIDEBAR -->
            
        
    </div>    

</div>


</body>
</html>

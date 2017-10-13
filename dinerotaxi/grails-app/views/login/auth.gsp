<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dinerotaxi" />

<script  type="text/javascript" src="${resource(dir:'js',file:'funciones1.js')}"></script>

</head>
<body>
<!-- MODAL -->


<div id="boxes">
    <div id="dialog" class="window">

    	<div class="modal">
        
        	<img src="images/dineroTaxi.png" alt="DineroTaxi.com" title="DineroTaxi.com" />
        	<h3>Bienvenido Juan Perez!</h3>
        	A partir de este momento puedes comenzar a<br /> utilizar los servicios de DINERO<b>TAXI</b>
            <br /><br />
            Confirmar para terminar el pedido.
            <br />

            <a href="realizarPedido.html" class="conagre"></a>
            <div class="clearFix"></div>
            <a href="realizarPedido.html" class="confirmar"></a>
            <a href="#" class="cancelar close"></a>
        	<!--<a href="#"class="close"/><img src="images/ejModal.jpg" alt="ejModal" border="0" /></a>-->
        </div>        
	</div>
    
    <div id="olvido" class="window">
        <div class="modal">

        
            <h3>Recuperar contraseña!</h3>
            <br />
            
            Ingrese su email y recibirá la contraseña en su casilla de correo
            <br />
            
            <form action="">
            
                    <div class="bloInMin_"><span class="flMin">Email</span>  <input id="mail" type="text" name="email" placeholder="ejemplo@mail.com" class="inputShortMin" /></div>
                                                               
                   	<a class="env_" href="" ></a>
                    <a href="#" class="cancelar close"></a>

          		</form>
                
            
            <!--<a href="#"class="close"/><img src="images/ejModal.jpg" alt="ejModal" border="0" /></a>-->
        </div>        
    </div>
   
    <div id="mask"></div>
</div>


<!-- FIN MODAL -->
	<div class="mainContent_">

		<div class="con">

			<div class="container">

	
		
            <g:if test="${flash.error}">
            	<div class="errors">${flash.error}</div>
				<script type="text/javascript">
					showErrorMessage();
				</script>
            </g:if>
					<g:render template="/template/login" />
				<!-- END LOGIN -->

				<!-- NEW USER -->

					
			<g:render template="/template/registration" />

				<!-- END NEW USER -->

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

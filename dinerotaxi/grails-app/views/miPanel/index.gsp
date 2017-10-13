<%@ page import="ar.com.operation.TRANSACTIONSTATUS" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dinerotaxiL" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- META for Google Webmasters -->
<meta name="google-site-verification"
	content="NBzIvboQVvrq0MoRtNg_bbN7g6Qf-zWkn6wDGarb0lk" />
<meta name="author" content="DineroTaxi" />
<meta name="version" content="1.0" />
<meta name="description"
	content="DineroTaxi es un servicio para pedir taxis de forma automatica desde el movil. Con DineroTaxi tienes tu taxi en tu movil">
<meta name="keywords"
	content="taxi quiero pedir solicitar Madrid Barcelona Sevilla Valencia automatico aqui ahora android iphone blackberry">
<meta name="copyright"
	content="Copyright (c) DineroTaxi.com Todos los derechos reservados." />
<!-- METAS for Facebook -->
<meta property="og:title" content="DineroTaxi" />
<meta property="og:type" content="company" />
<meta property="og:url" content="https://www.dinerotaxi.com" />
<meta property="og:image"
	content="${resource(dir:'img',file:'favicon.ico')}" />
<link rel="shortcut icon"
	href="${resource(dir:'img',file:'favicon.ico')}" type="image/x-icon" />
<link rel="apple-touch-icon-precomposed" href="${resource(dir:'images',file:'favicon.ico')}">
	
<%--	--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css/dinerotaxi',file:'modal.css')}" />--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />--%>
<%--   --%>

    <g:javascript library="jquery" plugin="jquery"/>
    <script type="text/javascript" src="${resource(dir:'js',file:'jquery-ui-1.8.16.custom.min.js')}"></script>

<!--SCRIPT VERSION EZE-->
<script type='text/javascript' src="${resource(dir:'js',file:'jquery.tools.min.js')}"></script>
<script type='text/javascript' src='${resource(dir:'js',file:'jquery.validate.js')}'></script>
<!--Google Analytics-->
	<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>
	
    <script src="${resource(dir:'js/imported',file:'jquery.tools.min.js')}"></script>
    <jq:plugin name="fileuploader"/>
    <jq:plugin name="editable"/>    
    <jq:plugin name="places"/>    
    <jq:plugin name="multiselect"/>
    <jq:plugin name="multiplace"/>
    <jq:plugin name="newscomment"/>
    <jq:plugin name="follow"/>
<!-- This JavaScript snippet activates those tabs -->
<script type='text/javascript' src='${resource(dir:'js/jquery',file:'jquery.validate.js')}'></script>

<script type='text/javascript' src='${resource(dir:'js/miPanel',file:'data.js')}'></script>
</head>
<body >

<div class="mainContent">

	<div class="con">
    	
        <div class="content mt10">        	
            
        	<!-- TABS -->
        
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
            
			<g:render template="buttons" model="['action':'pedido']" />
            <!-- DETAIL -->
            
            <div class="boxPanelUser">
            
            	<h1>Pedidos pendientes</h1>
                
                <div class="bgHeadList">
                	<div class="itemM">Desde</div>
                    <div class="itemM">Hasta</div>
                    <div class="itemSS">Fecha</div>
                    <div class="itemSS">Hora</div>
                    <div class="itemXSS">Taxi</div>
                </div>
                <g:each in="${opPending}" var="op">
	                <div class="itemList">
	                	<div class="itemM">${op?.favorites?.placeFrom?.street }&nbsp;${op?.favorites?.placeFrom?.streetNumber }</div>
	                    
	                    <g:if test="${op?.favorites?.placeTo}">
	                    	<div class="itemM">${op?.favorites?.placeTo?.street }&nbsp;${op?.favorites?.placeTo?.streetNumber }</div>
	                    </g:if>
	                    <g:else >
	                   		<div class="itemM">--</div>
	                    </g:else>
	                    <div class="itemSS"><fmt1:dateFormat format="dd/MM/yy" value="${op?.createdDate}"/></div>
	                    <div class="itemSS"><fmt1:dateFormat format="HH:mm:ss" value="${op?.createdDate}"/></div>
	                    <div class="itemXSS">${op?.taxista?.id?op?.taxista?.email.split('@')[0]:"-" }</div>
	                    <div class="itemS"><g:link  params="[country:"${params?.country?:''}"]" action="cancelOrder" class="cancelar" id="${op?.id}"></g:link></div>
	                </div>
                </g:each>
          		<br />
                <h1>Historial de pedidos</h1> 
                <g:form action="delete">
                	<g:if test="${operationInstanceList.size()!=0 }">
		                <div class="itemS mt10"><input type="submit" name="submit" value="" class="eliminar"></div>
		                 <div class="itemS mt10" style="margin-left:50px;">
		                  	  <span class="ui-button-text">
		                       <a href="#dialog" class="suprimirTodo" rel="#modal_elim_all_fav" ></a>
		                    </span>
		                   </div>    
		                
	                </g:if>        	
	                <div class="clearFix"></div>
	                <div class="bgHeadList">
	                	<div class="itemM">Desde</div>
	                    <div class="itemM">Hasta</div>
	                    <div class="itemSS">Fecha</div>
	                    <div class="itemSS">Hora</div>
	                    <div class="itemXSS">Taxi</div>
	                    <div class="itemSS">Estado</div>
	                    <div class="itemXSS">Borrar</div>
	                </div>
	                <g:if test="${operationInstanceList.size()!=0 }">
		                <g:each in="${operationInstanceList}" status="i" var="operationInstance">
			                <div class="itemList">
			          		 	<div class="itemM">${operationInstance?.favorites?.placeFrom?.street }&nbsp;${operationInstance?.favorites?.placeFrom?.streetNumber }</div>
			                    <g:if test="${operationInstance?.favorites?.placeTo}">
			                    	<div class="itemM">${operationInstance?.favorites?.placeTo?.street }&nbsp;${operationInstance?.favorites?.placeTo?.streetNumber }</div>
			                    </g:if>
			                    <g:else >
			                   		<div class="itemM">--</div>
			                    </g:else>
			                    <div class="itemSS"><fmt1:dateFormat format="dd/MM/yy" value="${operationInstance?.createdDate}"/></div>
			                    <div class="itemSS"><fmt1:dateFormat format="HH:mm:ss" value="${operationInstance?.createdDate}"/></div>
			                    <div class="itemXSS">${operationInstance?.taxista?.id?operationInstance?.taxista?.email.split('@')[0]:"-" }</div>
			                    
			                    <g:if test="${operationInstance?.status==TRANSACTIONSTATUS.COMPLETED}" >
			                     	<div class="itemXSS"><img src="${resource(dir:'images',file:'realizado.png')}" alt="Viaje Realizado" class="ml10" /></div>
			                    </g:if>
			                    <g:elseif test="${operationInstance?.status==TRANSACTIONSTATUS.CANCELED}" >
			                   		<div class="itemXSS"><img src="${resource(dir:'images',file:'suspendido.png')}" alt="Viaje Suspendido" class="ml10" /></div>
			                     
			                    </g:elseif>
			                    <g:else>
			                      	<div class="itemXSS"><img src="${resource(dir:'images',file:'cancelado.png')}" alt="Viaje Cancelado" class="ml10" /></div>
			                    </g:else>
			                                       
			                    <%--<label class="label_checkHome fixIe" for="checkbox-01"><input name="sample-checkbox-01" id="checkbox-01" value="1" type="checkbox" /></label>    
			                    
			                    --%><label class="label_checkHome fixIe" for="deleteChecked[${operationInstance?.id}]">
			                    <g:checkBox name="deleteChecked" value="${operationInstance?.id}"  id="deleteChecked[${operationInstance?.id}]" /></label>
			                    
			                </div>
		                </g:each>
		             
		                <div class="paged">
							<g:paginate total="${operationInstanceTotal}" />
						</div>
					</g:if>
            	<g:else>
            	 <div class="itemList">
                	<div class="itemM">Sin Elementos</div>
                    <!--<div class="itemXSS"><input name="" type="checkbox" value="" /></div>-->
                </div>
            	<br>
            	</g:else>
               </g:form>
            </div>
            
            <div class="clearFix"><br /></div>
            
            
         </div>   
        
          
           <g:render template="sidebar" model="" />
    
    </div>

</div>
<div class="clearFix"></div>

<!-- MODAL ELIMINAR TODOS FAVORITO-->
<div id="boxes">
    <div id="modal_elim_all_fav" class="window2">
        <g:form id="frm_modal_elim_all_fav" name="frm_modal_elim_all_fav" method="post" action="deleteAll">
        	
            <div class="blockInput_" style="height: 55px;"> 
                <label for="supr_favorito"><strong>¿Estas seguro que desea eliminar el historial de pedidos?</strong></label>
                <div class="btns_favoritos_elim">
	           <button type="button" class="no_fav_elim close"></button>
                   <input id="supr_favorito" name="supr_favorito" class="si_fav_elim" value="" type="submit" />
	         </div>
            </div>
        </g:form>
	</div>
    
   
    
    <div id="mask"></div>
</div>


<!--FIN MODAL -->
<!-- END MAIN -->
</body>
</html>

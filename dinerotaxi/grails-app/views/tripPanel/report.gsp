<%@ page import="ar.com.operation.TRANSACTIONSTATUS" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dineroTaxiCompanyL" />
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

<!--Google Analytics-->
	<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>
	
    <script src="${resource(dir:'js/imported',file:'jquery.tools.min.js')}"></script>
    <script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=true"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.simplemodal.1.4.2.min.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.validate.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'json2.js')}"></script>
    <script type="text/javascript" src="${resource(dir:'js/imported',file:'jquery.tokeninput.js')}"></script>
    <jq:plugin name="fileuploader"/>
    <jq:plugin name="editable"/>    
    <jq:plugin name="places"/>    
    <jq:plugin name="multiselect"/>
    <jq:plugin name="multiplace"/>
    <jq:plugin name="newscomment"/>
    <jq:plugin name="follow"/>
<!-- This JavaScript snippet activates those tabs -->
<script type='text/javascript' src='${resource(dir:'js/jquery',file:'jquery.validate.js')}'></script>

</head>
<body >

<div class="mainContent_">

	

	<div class="con">
	<div class="sidebar1 mt10">
		<g:render template="sidebar" />
    </div>
        <div class="content mt10">        	
            
        	<!-- TABS -->
        
            
            <!-- DETAIL -->
            
            <div class="boxPanelRadioTaxi">
            
            
            	
                <h1>Historial de Viajes</h1> 
                <g:form action="#">
                

	                <div class="clearFix"></div>
	                <div class="bgHeadRadioList_">
	                	<div class="itemM">Fecha</div>
	                    <div class="itemM">Viajes Sujeridos</div>
	                    <div class="itemM">Viajes Cancelados</div>
	                    <div class="itemM">Viajes Realizados</div>
	                    <div class="itemS">%</div>
	                </div>
	                <g:if test="${operationInstanceList.size()!=0 }">
		                <g:each in="${operationInstanceList}" status="i" var="operationInstance">
			                <div class="itemRadioList_">
			          		 	
			                    <div class="itemM"><fmt1:dateFormat format="dd/MM/yy" value="${operationInstance?.lastDate}"/></div>
			                    <div class="itemM">${operationInstance?.countTravel}</div>
			                    <div class="itemM">${operationInstance?.canceled}</div>
			                    <div class="itemM">${operationInstance?.total}</div>
			                    <div class="itemS">${operationInstance?.porcent}%</div>
			                </div>
		                </g:each>
					</g:if>
            	<g:else>
            	 <div class="itemList_">
                	<div class="itemM">Sin Elementos</div>
                    <!--<div class="itemXSS"><input name="" type="checkbox" value="" /></div>-->
                </div>
            	<br>
            	</g:else>
               </g:form>
            </div>
            
            <div class="clearFix"><br /></div>
            
            
         </div>   
        
          
    
    </div>

</div>
<div class="clearFix"></div>

<!-- END MAIN -->
</body>
</html>

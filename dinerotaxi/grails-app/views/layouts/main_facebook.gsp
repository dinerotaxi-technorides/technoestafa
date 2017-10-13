<!DOCTYPE html>
<html>
<head>
		<title><g:layoutTitle default="Dinerotaxi.com La nueva Manera de tomar un taxiDinerotaxi.com La nueva Manera de tomar un taxi" /></title>
		
		<meta name="description" content="Dinerotaxi.com La nueva Manera de tomar un taxi"/> 
		<meta name="keywords" content="Dinerotaxi.com La nueva Manera de tomar un taxi" />
		<meta name="author" content="Dinerotaxi.com">
		<meta name="google-site-verification" content="">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<!-- Styles -->
		<link rel="stylesheet" href="${resource(dir:'css',file:'style.css')}">
		<link rel="stylesheet" href="${resource(dir:'css',file:'master.css')}">
		<link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.css')}">
		<link rel="stylesheet" href="${resource(dir:'css/tablesorter',file:'tablesorter.css')}">
		<link rel="stylesheet" href="${resource(dir:'css',file:'autocomplete.css')}">
		<link rel="stylesheet" href="${resource(dir:'css/textlistbox',file:'TextboxList.Autocomplete.css')}">		
		<link rel="stylesheet" href="${resource(dir:'css/textlistbox',file:'TextboxList.css')}">
		<!-- Scripts-->
		<!--[if IE]>
		  <script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"></script>
		  <![endif]-->
		<g:javascript library="jquery" plugin="jquery"/>
		<script src="${resource(dir:'js/libs',file:'jquery-ui-1.8.14.custom.min.js')}"></script>
		<script src="${resource(dir:'js/libs',file:'jquery.tablesorter.min.js') }"></script>
		<script src="${resource(dir:'js/libs',file:'jquery.tools.min.js')}"></script>
		<script src="${resource(dir:'js/libs',file:'modernizr-1.7.min.js')}"></script>
		<script src="${resource(dir:'js/libs',file:'iepp.js')}"></script>
		<script src="${resource(dir:'js/libs',file:'trade.js')}"></script>
		<script src="${resource(dir:'js/libs',file:'slider.js')}"></script>
		<script src="${resource(dir:'js/libs',file:'tooltip.js')}"></script>
		<script src="${resource(dir:'js/textlistbox',file:'TextboxList.js')}"></script>
		<script src="${resource(dir:'js/textlistbox',file:'TextboxList.Autocomplete.js')}"></script>
		<script src="${resource(dir:'js/textlistbox',file:'TextboxList.Autocomplete.Binary.js')}"></script>
		<script src="${resource(dir:'js/textlistbox',file:'GrowingInput.js')}"></script>
		<!-- My Scripts-->
		<script src="${resource(dir:'js/mylibs/coda-slider-2.0',file:'jquery.easing.1.3.js')}"></script>
		<script src="${resource(dir:'js/mylibs',file:'swfobject.js')}"></script>		
		<script src="${resource(dir:'js/mylibs',file:'twitter-1.13.1.min.js')}"></script>	
		<script src="${resource(dir:'js/mylibs',file:'jquery.vticker.1.4.js')}"></script>	
		<script src="${resource(dir:'js/mylibs',file:'jquery.newsTicker.js')}"></script>
		<script src="${resource(dir:'js/',file:'myscripts.js')}"></script>	
		<script src="${resource(dir:'js/mylibs',file:'autocomplete.js')}"></script>	
		<script src="https://www.google.com/jsapi"></script>

		<!-- External Scripts-->
		<script src="https://platform.twitter.com/widgets.js"></script>
		<script src="https://apis.google.com/js/plusone.js">{lang: 'es-419'}</script>
		<script src="https://connect.facebook.net/en_US/all.js#xfbml=1"></script>
		<!-- Open Graph Protocol Tags http://ogp.me/ -->
		<meta property="og:url" content="https://www.freddo.com/" />
		<meta property="og:title" content="Dinerotaxi.com La nueva Manera de tomar un taxi" />
		<meta property="og:type" content="Commerce" />
		<meta property="og:image" content="https://profile.ak.fbcdn.net/hprofile-ak-snc4/hs338.snc4/41815_118194909773_909_n.jpg" />
		<meta property="fb:app_id" content="${facebookContext.app.id}" />
		<meta property="og:site_name" content="Dinerotaxi.com La nueva Manera de tomar un taxi" />
		<meta property="og:description" content="" />
	 	<gui:resources components="['autoComplete']" />
<g:layoutHead />
</head>
<body>
	<div id="fb-root"></div>
	<g:render template="/templates/common/facebookIntegration" />
	<div id="spinner" class="spinner" style="display: none;">
		<img src="${resource(dir:'images',file:'spinner.gif')}"
			alt="${message(code:'spinner.alt',default:'Loading...')}" />
	</div>
	<!-- Container -->
	<div id="container">
		<header>
			<div id="newheaderfb">
				<g:render template="/templates/common/headerFB" />
			</div>
		</header>
		<!-- Main -->
		<div id="main" class="FB" role="main">
			<div class="span-17" style="margin-left:3em;">	
				<div class="alert-message success" id="messageSuccess"
					style="display: none; margin-bottom:0 !important;" >
					<a href="#" class="close" onclick="$('#messageSuccess').fadeOut(); $('#messageSuccess').overlay().close();">&times;</a>
					<div id="messageSuccessContent"></div>
	
				</div>
				<div class="alert-message error" id="messageError"
					style="display: none; margin-bottom:0 !important;" >
					<a href="#" class="close" onclick="$('#messageError').fadeOut(); $('#messageError').overlay().close();">&times;</a>
					<div id="messageErrorContent"></div>
				</div>
			</div>
			<hr class="space" />
			<!-- Content -->
			<section id="body_section" class="span-12">
				<g:if test="${flash.errorMessages}">
					<div class='error' id='flashMessages'>
						${flash.errorMessages}
					</div>
				</g:if>
				<g:if test="${flash.successMessages}">
					<div class='success' id='flashMessages'>
						${flash.successMessages}
					</div>
				</g:if>
				<g:if test="${flash.infoMessages}">
					<div class='info' id='flashMessages'>
						${flash.infoMessages}
					</div>
				</g:if>
				<g:layoutBody />
			</section>

			<section id="sidebar_section" class="span-7">
				<span id="sidebarContainer"></span>
			</section>


			<!-- Main Ends -->
			<div id='messagesBox'></div>
		</div>
		<!-- Footer -->
		<%--			<g:render template="/templates/common/footer"/>	--%>
	</div>
	<!-- Container Ends -->
	<script src="${resource(dir:'js',file:'plugins.js')}"></script>
	<script src="${resource(dir:'js',file:'script.js')}"></script>
	<script src="${resource(dir:'js',file:'rwasn.js')}"></script>

	<!-- Start JS Initialization-->

	<div id="tradeBoxContainer" class="modal"
		style="display: none; margin-top: -250px; margin-left: -250px; z-index: 99"></div>

	
</body>
</html>
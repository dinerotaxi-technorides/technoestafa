

<%@ page import="com.Orders" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="admin" />
<g:set var="entityName"
	value="${message(code: 'orders.label', default: 'Orders')}" />
<title><g:message code="default.list.label" args="[entityName]"
		default="Listado Orders" /></title>
<export:resource />
</head>
<body  onLoad="">
	<div id="main" role="main">
		<hr class="space" />
		<h1>
			<g:message code="default.lis11t.label" args="[entityName]"
				default="Ordenes Pendientes" />
		</h1>
		<g:if test="${flash.message}">
			<div class="message">${flash.message}</div>
		</g:if>

		<section id="abm">
			
			<section class="clearfix">
				<div class="left">
					<button class="selected"
						onclick="javascript:window.location.replace(${createLink(uri: '/')})">
						<i class="home"></i><a class="home" href="${createLink(uri: '/')}">Home</a>
					</button>
					
				</div>
				<div class="right">
					
				</div>
			</section>
			<table class="listings" summary="">
				<thead>
					<tr>
						<th></th>
						
                                          <g:sortableColumn property="id" title="${message(code: 'orders.id.label', default: 'Id')}" />
                                        
                                          <g:sortableColumn property="user" title="${message(code: 'orders.user.label', default: 'User')}" />
                                        
                                          <g:sortableColumn property="device" title="${message(code: 'orders.device.label', default: 'Device')}" />
                                        
                                          <g:sortableColumn property="paymentMethod" title="${message(code: 'orders.paymentMethod.label', default: 'Payment Method')}" />
                                        
                                          <g:sortableColumn property="shipper" title="${message(code: 'orders.shipper.label', default: 'Shipper')}" />
                                        
                                          <g:sortableColumn property="total" title="${message(code: 'orders.total.label', default: 'Total')}" />
                                        

						<th nowrap><label><g:message code="ver.label"
									default="Ver" /> </label>
						</th>

					</tr>
				</thead>
				<tbody>

					<g:each in="${ordersInstanceList}" status="i"
						var="ordersInstance">
						<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<td><input name="item" type="checkbox" value=""></td>
							  
                              <td>${fieldValue(bean:ordersInstance, field:'id')}</td>
                          
                              <td>${fieldValue(bean:ordersInstance, field:'user')}</td>
			   
                              <td>${fieldValue(bean:ordersInstance, field:'device')}</td>
			   
                              <td>${fieldValue(bean:ordersInstance, field:'paymentMethod')}</td>
                          
                              <td>${fieldValue(bean:ordersInstance, field:'shipper')}</td>
                          
                              <td>${fieldValue(bean:ordersInstance, field:'total')}</td>
                          
							<td><g:link  params="[country:"${params?.country?:''}"]" action="show" class="show"
									id="${ordersInstance.id}">&nbsp;</g:link>
							</td>
						</tr>
					</g:each>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="9"><g:paginate total="${ordersInstanceTotal}" max="5" />
						</th>
					</tr>

				</tfoot>
			</table>
		</section>
	</div>

</body>
</html>

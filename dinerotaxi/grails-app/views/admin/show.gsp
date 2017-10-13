

<%@ page import="com.Orders"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="admin" />
<g:set var="entityName"
	value="${message(code: 'orders.label', default: 'Orders')}" />
<title><g:message code="default.show.label" args="[entityName]"
		default="Ver Orders" />
</title>
</head>
<body>
	<div id="main" role="main">
		<hr class="space" />

		<div class="body">
			<h1>
				<g:message code="default.shossw.label" args="[entityName]"
					default="Detalle del Pedido" />
			</h1>
			<g:if test="${flash.message}">
				<div class="notice">
					${flash.message}
				</div>
			</g:if>
			<div class="nav">
				<button class="selected"
					onclick="javascript:window.location.replace(${createLink(uri: '/')})">
					<i class="home"></i><a class="home" href="${createLink(uri: '/')}">Home</a>
				</button>

			</div>

			<div class="dialog">
				<table class="listings">
					<thead>
						<tr class="prop">
							<th valign="top" class="name">Name:</th>

							<th valign="top" class="value">Value:</th>

						</tr>
					</thead>
					<tbody>


						<tr class="prop">
							<td valign="top" class="name">Id:</td>

							<td valign="top" class="value">
								${fieldValue(bean:ordersInstance, field:'id')}
							</td>

						</tr>

						<tr class="prop">
							<td valign="top" class="name">User:</td>

							<td valign="top" class="value"><g:link  params="[country:"${params?.country?:''}"]" controller="user"
									action="show" id="${ordersInstance?.user?.id}">
									${ordersInstance?.user?.encodeAsHTML()}
								</g:link></td>

						</tr>


						<tr class="prop">
							<td valign="top" class="name">Shipper:</td>

							<td valign="top" class="value"><g:link  params="[country:"${params?.country?:''}"]" controller="shippers"
									action="show" id="${ordersInstance?.shipper?.id}">
									${ordersInstance?.shipper?.encodeAsHTML()}
								</g:link></td>

						</tr>

						<tr class="prop">
							<td valign="top" class="name">Payment Method:</td>

							<td valign="top" class="value"><g:link  params="[country:"${params?.country?:''}"]" controller="payment"
									action="show" id="${ordersInstance?.paymentMethod?.id}">
									${ordersInstance?.paymentMethod?.encodeAsHTML()}
								</g:link></td>

						</tr>


						<tr class="prop">
							<td valign="top" class="name">Device:</td>

							<td valign="top" class="value"><g:link  params="[country:"${params?.country?:''}"]" controller="device"
									action="show" id="${ordersInstance?.device?.id}">
									${ordersInstance?.device?.encodeAsHTML()}
								</g:link></td>

						</tr>

						<tr class="prop">
							<td valign="top" class="name">Order Details:</td>

							<td valign="top" style="text-align: left;" class="value">
								<ul>
									<g:each var="o" in="${ordersInstance.orderDetails}">
										<li><g:link  params="[country:"${params?.country?:''}"]" controller="orderDetails" action="show"
												id="${o.id}">
												${o?.encodeAsHTML()}
											</g:link></li>
										<g:if test="${o?.catalog?.id}">


										<ul>
											<li><g:link  params="[country:"${params?.country?:''}"]" controller="catalog" action="show"
													id="${o?.catalog?.id}">
													${o?.catalog?.encodeAsHTML()}
												</g:link></li>

										</ul>
										
										</g:if>
									</g:each>
								</ul>
							</td>

						</tr>

						<tr class="prop">
							<td valign="top" class="name">Total:</td>

							<td valign="top" class="value">
								${fieldValue(bean:ordersInstance, field:'total')}
							</td>

						</tr>
					</tbody>
					<tfoot>
						<tr>
							<th></th>
							<th></th>
						</tr>
					</tfoot>
				</table>
			</div>
			<div class="buttons">
				<button class="selected"
					onclick="javascript:window.location.replace(${createLink(uri: '/')})">
					<i class="home"></i><a class="home" href="${createLink(uri: '/')}">Home</a>
				</button>
			</div>
		</div>
	</div>
</body>
</html>

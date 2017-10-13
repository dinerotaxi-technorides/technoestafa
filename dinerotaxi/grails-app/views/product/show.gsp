

<%@ page import="com.Product" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="admin" />
<g:set var="entityName"
	value="${message(code: 'product.label', default: 'Product')}" />
<title><g:message code="default.show.label" args="[entityName]"
		default="Ver Product" />
</title>
</head>
<body>
	<div id="main" role="main">
		<hr class="space" />
		
		<div class="body">
			<h1>
				<g:message code="default.show.label" args="[entityName]"
					default="Ver Product" />
			</h1>
			<g:if test="${flash.message}">
				<div class="notice">${flash.message}</div>
			</g:if>
				<div class="nav">
				<button class="selected"
					onclick="javascript:window.location.replace(${createLink(uri: '/')})">
					<i class="home"></i><a class="home" href="${createLink(uri: '/')}">Home</a>
				</button>
				<button
					onclick="javascript:window.location.replace('<g:createLink params="[country:"${params?.country?:''}"]"  action="list"/>')">
					<i class="user"></i><g:message code="default.list.label" args="[entityName]"
						default="Listado Product" />
				</button>
				<button
					onclick="javascript:window.location.replace('<g:createLink params="[country:"${params?.country?:''}"]"  action="create"/>')">
					<i class="user"></i><g:message code="default.new.label" args="[entityName]"
							default="Nuevo Product" />
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
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'id')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Created Date:</td>
                            
                              <td><fmt:dateFormat value="${productInstance.createdDate}" format="dd/MM/yyyy"/></td>
			   
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Last Modified Date:</td>
                            
                              <td><fmt:dateFormat value="${productInstance.lastModifiedDate}" format="dd/MM/yyyy"/></td>
			   
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Catalog:</td>
                            
                            <td valign="top" class="value"><g:link  params="[country:"${params?.country?:''}"]" controller="catalog" action="show" id="${productInstance?.catalog?.id}">${productInstance?.catalog?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Name:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'name')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Description:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'description')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Quantity Per Unit:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'quantityPerUnit')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Unit Price:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'unitPrice')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Discount:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'discount')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Unit Stock:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'unitStock')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Ranking:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'ranking')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Category:</td>
                            
                            <td valign="top" class="value"><g:link  params="[country:"${params?.country?:''}"]" controller="category" action="show" id="${productInstance?.category?.id}">${productInstance?.category?.encodeAsHTML()}</g:link></td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Discount Availble:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'discountAvailble')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Note:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'note')}</td>
                          
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Product Available:</td>
                            
                            <td valign="top" class="value">${fieldValue(bean:productInstance, field:'productAvailable')}</td>
                          
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
				<g:form>
					<input type="hidden" name="id" value="${productInstance?.id}" />
					<span class="button"><g:actionSubmit class="edit"
							action="edit"
							value="${message(code: 'default.button.edit.label', default: 'Modificar')}" />
					</span>
					<span class="button"><g:actionSubmit class="delete"
							action="delete"
							value="${message(code: 'default.button.delete.label', default: 'Borrar')}"
							onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" />
					</span>

				</g:form>
			</div>
		</div>
	</div>
</body>
</html>

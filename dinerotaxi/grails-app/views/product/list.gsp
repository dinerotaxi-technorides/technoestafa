

<%@ page import="com.Product" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="admin" />
<g:set var="entityName"
	value="${message(code: 'product.label', default: 'Product')}" />
<title><g:message code="default.list.label" args="[entityName]"
		default="Listado Product" /></title>
<export:resource />
</head>
<body >
	<div id="main" role="main">
		<hr class="space" />
		<h1>
			<g:message code="default.list.label" args="[entityName]"
				default="Listado Product" />
		</h1>
		<g:if test="${flash.message}">
			<div class="message">${flash.message}</div>
		</g:if>

		<section id="abm">
			<g:render
				template="/product/search" />
			<section class="clearfix">
				<div class="left">
					<button class="selected"
						onclick="javascript:window.location.replace(${createLink(uri: '/')})">
						<i class="home"></i><a class="home" href="${createLink(uri: '/')}">Home</a>
					</button>
					<button
						onclick="javascript:window.location.replace('<g:createLink params="[country:"${params?.country?:''}"]"  action="create"/>')">
						<i class="user"></i><g:message code="default.new.label" args="[entityName]"
						default="Nuevo Product" />
					</button>
				</div>
				<div class="right">
					<button class="color red">
						<i class="trash"></i>Eliminar
					</button>
				</div>
			</section>
			<table class="listings" summary="">
				<thead>
					<tr>
						<th></th>
						
                                          <g:sortableColumn property="id" title="${message(code: 'product.id.label', default: 'Id')}" />
                                        
                                          <g:sortableColumn property="createdDate" title="${message(code: 'product.createdDate.label', default: 'Created Date')}" />
                                        
                                          <g:sortableColumn property="lastModifiedDate" title="${message(code: 'product.lastModifiedDate.label', default: 'Last Modified Date')}" />
                                        
                                          <th><g:message code="product.catalog.label" default="Catalog" /></th>
                                          
                                          <g:sortableColumn property="name" title="${message(code: 'product.name.label', default: 'Name')}" />
                                        
                                          <g:sortableColumn property="description" title="${message(code: 'product.description.label', default: 'Description')}" />
                                        

						<th nowrap><label><g:message code="editar.label"
									default="Editar" /> </label>
						</th>
						<th nowrap><label><g:message code="ver.label"
									default="Ver" /> </label>
						</th>

					</tr>
				</thead>
				<tbody>

					<g:each in="${productInstanceList}" status="i"
						var="productInstance">
						<tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
							<td><input name="item" type="checkbox" value=""></td>
							
                              <td>${fieldValue(bean:productInstance, field:'id')}</td>
                          
                              <td><fmt:dateFormat value="${productInstance.createdDate}" format="dd/MM/yyyy"/></td>
			   
                              <td><fmt:dateFormat value="${productInstance.lastModifiedDate}" format="dd/MM/yyyy"/></td>
			   
                              <td>${fieldValue(bean:productInstance, field:'catalog')}</td>
                          
                              <td>${fieldValue(bean:productInstance, field:'name')}</td>
                          
                              <td>${fieldValue(bean:productInstance, field:'description')}</td>
                          
							<td><g:link  params="[country:"${params?.country?:''}"]" action="edit" class="edit"
									id="${productInstance.id}">&nbsp;</g:link>
							</td>
							<td><g:link  params="[country:"${params?.country?:''}"]" action="show" class="show"
									id="${productInstance.id}">&nbsp;</g:link>
							</td>
						</tr>
					</g:each>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="9"><g:paginate total="${productInstanceTotal}" max="5" />
						</th>
					</tr>

				</tfoot>
			</table>
		</section>
	</div>

</body>
</html>



<%@ page import="com.Product"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="admin" />
<g:set var="entityName"
	value="${message(code: 'product.label', default: 'Product')}" />
<title><g:message code="default.create.label"
		args="[entityName]" default="Nuevo Product" />
</title>
</head>
<body>
	<div id="main" role="main">
		<hr class="space" />

		<div class="body">
			<h1></h1>
			<g:if test="${flash.message}">
				<div class="notice">
					${flash.message}
				</div>
			</g:if>
			<g:hasErrors bean="${productInstance}">
				<div class="error">
					<g:renderErrors bean="${productInstance}" as="list" />
				</div>
			</g:hasErrors>

			<div class="nav">
				<button class="selected"
					onclick="javascript:window.location.replace(${createLink(uri: '/')})">
					<i class="home"></i><a class="home" href="${createLink(uri: '/')}">Home</a>
				</button>
				<button
					onclick="javascript:window.location.replace('<g:createLink params="[country:"${params?.country?:''}"]"  action="list"/>')">
					<i class="user"></i>
					<g:message code="default.list.label" args="[entityName]"
						default="Listado Product" />
				</button>
			</div>
			<section id="backend">
				<g:form action="save" method="post">

					<fieldset>
						<legend>
							<g:message code="default.create.label" args="[entityName]"
								default="Nuevo Product" />
						</legend>

						<p>

							<label for="createdDate"><g:message
									code="product.createdDate.label" default="Created Date" />:</label>


							<g:datePicker name="createdDate" precision="day"
								value="${productInstance?.createdDate}" noSelection="['': '']" />
						</p>

						<p>

							<label for="lastModifiedDate"><g:message
									code="product.lastModifiedDate.label"
									default="Last Modified Date" />:</label>


							<g:datePicker name="lastModifiedDate" precision="day"
								value="${productInstance?.lastModifiedDate}"
								noSelection="['': '']" />
						</p>

						<p>

							<label for="catalog"><g:message
									code="product.catalog.label" default="Catalog" />:</label>

							<g:select name="catalog1.id" size="5" multiple="yes"
								from="${com.Catalog.list()}" optionKey="id"
								value="${productInstance?.catalog}" noSelection="['null': '']" />
						</p>

						<p>

							<label for="name"><g:message code="product.name.label"
									default="Name" />:</label>


							<g:textField name="name" value="${productInstance?.name}" />
						</p>

						<p>

							<label for="description"><g:message
									code="product.description.label" default="Description" />:</label>


							<g:textField name="description"
								value="${productInstance?.description}" />
						</p>

						<p>

							<label for="quantityPerUnit"><g:message
									code="product.quantityPerUnit.label"
									default="Quantity Per Unit" />:</label>


							<g:textField name="quantityPerUnit"
								value="${fieldValue(bean: productInstance, field: 'quantityPerUnit')}" />
						</p>

						<p>

							<label for="unitPrice"><g:message
									code="product.unitPrice.label" default="Unit Price" />:</label>


							<g:textField name="unitPrice"
								value="${fieldValue(bean: productInstance, field: 'unitPrice')}" />
						</p>

						<p>

							<label for="discount"><g:message
									code="product.discount.label" default="Discount" />:</label>


							<g:textField name="discount"
								value="${fieldValue(bean: productInstance, field: 'discount')}" />
						</p>

						<p>

							<label for="unitStock"><g:message
									code="product.unitStock.label" default="Unit Stock" />:</label>


							<g:textField name="unitStock"
								value="${fieldValue(bean: productInstance, field: 'unitStock')}" />
						</p>

						<p>

							<label for="ranking"><g:message
									code="product.ranking.label" default="Ranking" />:</label>


							<g:textField name="ranking"
								value="${fieldValue(bean: productInstance, field: 'ranking')}" />
						</p>

						<p>

							<label for="category"><g:message
									code="product.category.label" default="Category" />:</label>


							<g:select name="category.id" from="${com.Category.list()}"
								optionKey="id" value="${productInstance?.category?.id}" />
						</p>

						<p>

							<label for="discountAvailble"><g:message
									code="product.discountAvailble.label"
									default="Discount Availble" />:</label>


							<g:checkBox name="discountAvailble"
								value="${productInstance?.discountAvailble}" />
						</p>

						<p>

							<label for="note"><g:message code="product.note.label"
									default="Note" />:</label>


							<g:textField name="note" value="${productInstance?.note}" />
						</p>

						<p>

							<label for="productAvailable"><g:message
									code="product.productAvailable.label"
									default="Product Available" />:</label>


							<g:checkBox name="productAvailable"
								value="${productInstance?.productAvailable}" />
						</p>

						<p>
							<input type="submit"
								value="${message(code: 'default.button.create.label', default: 'Crear')}">
						</p>
		</div>
		</fieldset>
		</g:form>

		</section>
	</div>
	</div>


</body>
</html>


<script type="text/javascript">
	function cleanForm() {

		document.getElementById("errLoc").value = "";

		document.getElementById("errMsg").value = "";

	}
</script>
<div class="span-24 last">
	<input type="button" name="btn" id="btn" value="Ocultar Filtros"
		onclick="doExpandCollapse('search')">
	<g:form action="search" method="post" name="search" id="search"
		onsubmit="validarStruct()">
		<fieldset>
			<legend>Buscar</legend>


			<p>
			<p>
			<p>
			<p>


				<label for="errLoc"><g:message code="orders.errLoc.label"
						default="Err Loc" /></label>
				<g:textField name="errLoc" value="${ordersInstance?.errLoc}" />



				<label for="errMsg"><g:message code="orders.errMsg.label"
						default="Err Msg" /></label>
				<g:textField name="errMsg" value="${ordersInstance?.errMsg}" />


			</p>
			<p></p>
			<p></p>
			<p></p>
			<p></p>
			<p></p>
			<p></p>
			<p></p>
			<p></p>

			<div class="nav">
				<button onclick="javascript:submit()">
					<i class="search"></i>Buscar
				</button>
				&nbsp;
				<button class="color blue" onclick="cleanForm()">
					<i class="archive"></i>Clean
				</button>
			</div>
		</fieldset>

	</g:form>
</div>

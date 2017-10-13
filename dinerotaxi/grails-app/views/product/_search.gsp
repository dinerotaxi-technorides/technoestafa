
<script type="text/javascript">
  function cleanForm(){
	

			document.getElementById("name").value="";
                    

			document.getElementById("description").value="";
                    

			document.getElementById("note").value="";
                    
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
                            
                            
								  <label for="name"><g:message code="product.name.label" default="Name" /></label>
								   <g:textField name="name" value="${productInstance?.name}" />
                        
                            
                            
								  <label for="description"><g:message code="product.description.label" default="Description" /></label>
								   <g:textField name="description" value="${productInstance?.description}" />
                        
                            
								</p>
								<p>
                            
                            
                            
								</p>
								<p>
                            
                            
                            
								</p>
								<p>
                            
                            
                            
								</p>
								<p>
                            
                            
                            
								</p>
								<p>
                            
                            
                            
								</p>
								<p>
                            
                            
                            
								</p>
								<p>
                            
                            
                            
								</p>
								<p>
                            
                            
								  <label for="note"><g:message code="product.note.label" default="Note" /></label>
								   <g:textField name="note" value="${productInstance?.note}" />
                        
                            
                            
						 </p>
	
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

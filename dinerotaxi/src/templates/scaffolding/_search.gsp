<% import org.codehaus.groovy.grails.orm.hibernate.support.ClosureEventTriggeringInterceptor as Events %>
<script type="text/javascript">
  function cleanForm(){
	<%excludedProps = ['version', 'id']
           props = domainClass.properties.findAll { !excludedProps.contains(it.name) }
            Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
            props.each { p ->
                if(!Collection.class.isAssignableFrom(p.type)) {
                    cp = domainClass.constrainedProperties[p.name]
                    display = (cp ? cp.display : true)
                    if(display) {
                        if(p.type.toString().contains("String")){%>

			document.getElementById("${p.name}").value="";
                    <%}}
                }
            }%>
}
</script>
<div class="span-24 last">
	<input type="button" name="btn" id="btn" value="Ocultar Filtros"
		onclick="doExpandCollapse('search')">
	<g:form action="search" method="post" name="search" id="search"
		onsubmit="validarStruct()">
		<fieldset>
			<legend>Buscar</legend>
			  <%

                            excludedProps = ['version',
                                             'id',
                                               Events.ONLOAD_EVENT,
                                               Events.BEFORE_DELETE_EVENT,
                                               Events.BEFORE_INSERT_EVENT,
                                               Events.BEFORE_UPDATE_EVENT]
                            props = domainClass.properties.findAll { !excludedProps.contains(it.name) }
                            int a=2
                            boolean hasEnd=false
                            Collections.sort(props, comparator.constructors[0].newInstance([domainClass] as Object[]))
                            props.each { p ->
                                if(!Collection.class.isAssignableFrom(p.type)) {
                                    cp = domainClass.constrainedProperties[p.name]
                                    display = (cp ? cp.display : true)
                                    if(display) { %>
                            <%if(a==2 ){%>
                            	 <p>
                            <%}
                            if(!(a%4)&&(a!=2)){%>
								</p>
								<p>
                            <%}%>
                            <%if(p.type.toString().contains("String")){%>
								  <label for="${p.name}"><g:message code="${domainClass.propertyName}.${p.name}.label" default="${p.naturalName}" /></label>
								   ${renderEditor(p)}
                        <%  a++}}   }   } %>
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

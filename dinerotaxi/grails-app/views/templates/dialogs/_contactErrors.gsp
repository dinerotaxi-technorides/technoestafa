<g:if test="${errors.size()>0}">
	<div class="error">
		<span><g:message code='contacterrors.title'/></span><br/>
		<g:each in="${errors}" var="error">
			<span style="padding-left: 10px">-${error}</span><br/>
		</g:each>
	</div>
</g:if>
<g:else>
	<div class="success">
		<span><g:message code='contacterrors.success'/><a href="#" onclick="showForm()"><g:message code='contacterrors.here'/></a></span><br/>
	</div>
</g:else>

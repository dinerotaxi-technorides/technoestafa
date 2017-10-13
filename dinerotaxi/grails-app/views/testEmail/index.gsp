<%@ page import="ar.com.goliath.TypeEmployer"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
</head>
<body>
	<g:form action="update">
	<p>${flash?.message }</p>
	<p>Email:</p>
		<g:textField name="email" value="" />
	<p>Body:</p>
		<g:textArea name="textArea"  rows="40" cols="100"/>
		<g:submitButton name="update" value="Send" />
	</g:form>

	
</body>
</html>

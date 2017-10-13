<div class="">
    Forgot password
    <p>
    <g:link  params="[country:"${params?.country?:''}"]" controller="auth" action="doPasswordReset" id="${user.passwordReset}" absolute="true"><g:message code="passwd.email.body"/></g:link>
</div>

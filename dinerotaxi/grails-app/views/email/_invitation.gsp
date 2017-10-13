<div class="">
    Invitiation to join 3baysover.com from ${req.fromUser}
    <p>
    ${req.message}
    <p>
    <g:link  params="[country:"${params?.country?:''}"]" controller="auth" action="signupCompany" id="${req.token}" absolute="true">Click here to sign up</g:link>
</div>

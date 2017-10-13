request    = require 'request'
config     = require '../../config'

@sendMail = (opId, template) ->
  options =
    'url' : config.api_host + 'technoRidesEmailApi/generic_email?opId=' + opId + '&template=' + template
  console.log JSON.stringify options

  request.get options, @onMail

@sendMailPayment = (opId, params, template) ->
  options =
    'url' : config.api_host + 'technoRidesEmailApi/payment_email?opId=' + opId + '&ccId=' + params.ccId + '&orderId=' + params.orderId + '&template=' + template
  console.log JSON.stringify options

  request.get options, @onMail

@onMail = (error, response, body) ->
  if error?
    console.log 'Message error: ' + error
  else
    console.log 'Message sent: ' + JSON.stringify body
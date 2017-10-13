Q          = require 'q'

payment    = require '../tasks/payment_utils'
config     = require '../../config'
request    = require 'request'

reports      = require '../dbs/reports'

log        = require('../log').create 'Adyen'


class @AdyenPaymentProcessor
  @getAdyenURL: (environment) ->
    adyen_url = "https://pal-test.adyen.com/pal/adapter/httppost"

    if environment == "LIVE"
      adyen_url = "https://pal-live.adyen.com/pal/adapter/httppost"

    if environment == "NONE"
      adyen_url = "https://example.com"

    return adyen_url


  @notifyPaymentsDisabled: (response) ->
    log.e "payment attempt by company without mobile payments. Request: #{JSON.stringify body}"
    res.send '{status:"401", detail:"app settings not enabled for mobile payments"}'


  @encryptedPayment: (req, res, next) ->
    log.i "encryptedPayment"

    try
      body = req.body

      _action            = "Payment.authorise"
      _amount_currency   = body.currency
      _amount_value      = body.value
      _merchant_account  = body.merchantAccount
      _reference         = body.reference
      _shopper_email     = body.shopperEmail
      _shopper_reference = body.shopperReference
      _card_encrypted    = body.cardData
      _environment       = body.environment
      _contract          = body.contract
      _generationtime    = body.generationtime

      adyen_url = @getAdyenURL _environment

      if _environment == "NONE"
        @notifyPaymentsDisabled res
        return

      options =
        'url' : adyen_url,
        'form' :
          'action'                         : _action
          'paymentRequest.amount.currency' : _amount_currency
          'paymentRequest.amount.value'    : _amount_value
          'paymentRequest.merchantAccount' : _merchant_account
          'paymentRequest.reference'       : _reference
          'paymentRequest.shopperEmail'    : _shopper_email
          'paymentRequest.shopperReference': _shopper_reference
          'generationtime'                 : _generationtime

          'paymentRequest.additionalData.card.encrypted.json': _card_encrypted
        'auth' :
          'user'    : config.adyen_users[_merchant_account].user
          'password': config.adyen_users[_merchant_account].password

      if _contract?
        options['form']['paymentRequest.recurring.contract'] = _contract

      log.d "REQUEST"

      log.d "OPTIONS: #{JSON.stringify options}"

      Q.nfcall(request.post, options)
      .then (http_response, body) ->
        log.d "REPONSE"
        payment.savePayment(_reference, _merchant_account, _environment, _amount_currency, _amount_value, _contract, http_response)
        res.send http_response

      .fail (err) ->
        log.ex err, "recurringDetails", "body: #{JSON.stringify body}"
        res.send '{status:"400", detail:"adyen error"}'
    catch err
      log.ex err, "payment", "body: #{JSON.stringify body}"
      res.send '{status:"400", detail:"adyen error"}'


  @paymentRecurring: (req, res, next) ->
    log.i "payment recurring"
    body = req.body

    try
      body = req.body

      _action              = "Payment.authorise"
      _amount_currency     = body.currency
      _amount_value        = body.value
      _merchant_account    = body.merchantAccount
      _reference           = body.reference
      _shopper_email       = body.shopperEmail
      _shopper_reference   = body.shopperReference
      _card_cvc            = body.cardCvc
      _detail_reference    = body.selectedRecurringDetailReference
      _shopper_interaction = "Ecommerce"
      _contract            = "ONECLICK"
      _environment         = body.environment

      adyen_url = @getAdyenURL _environment

      if _environment == "NONE"
        @notifyPaymentsDisabled res
        return

      options =
        'url' : adyen_url,
        'form' :
          'action'                         : _action
          'paymentRequest.amount.currency' : _amount_currency
          'paymentRequest.amount.value'    : _amount_value
          'paymentRequest.merchantAccount' : _merchant_account
          'paymentRequest.reference'       : _reference
          'paymentRequest.shopperEmail'    : _shopper_email
          'paymentRequest.shopperReference': _shopper_reference
          'paymentRequest.card.cvc'        : _card_cvc

          'paymentRequest.selectedRecurringDetailReference': _detail_reference

          'paymentRequest.shopperInteraction': _shopper_interaction
          'paymentRequest.recurring.contract': _contract
        'auth' :
          'user'    : config.adyen_users[_merchant_account].user
          'password': config.adyen_users[_merchant_account].password

      log.d "OPTIONS: #{JSON.stringify options}"

      Q.nfcall(request.post, options)
      .then (http_response, body) ->
        payment.savePayment(_reference, _merchant_account, _environment, _amount_currency, _amount_value, _contract, http_response)
        res.send http_response
      .fail (err) ->
        log.ex err, "recurringDetails", "body: #{JSON.stringify body}"
        res.send '{status:"400", detail:"adyen error"}'
    catch err
      log.ex err, "paymentRecurring", "body: #{JSON.stringify body}"
      res.send '{status:"400", detail:"adyen error"}'




  @recurringDetails: (req, res, next) ->
    log.i "recurring details"

    try
      body = req.body

      _action            = "Recurring.listRecurringDetails"
      _merchant_account  = body.merchantAccount
      _shopper_reference = body.shopperReference
      _contract          = "ONECLICK"
      _environment       = body.environment

      adyen_url = @getAdyenURL _environment

      if _environment == "NONE"
        @notifyPaymentsDisabled res
        return

      options =
        'url' : adyen_url,
        'form' :
          'action'                                    : _action
          'recurringDetailsRequest.merchantAccount'   : _merchant_account
          'recurringDetailsRequest.shopperReference'  : _shopper_reference
          'recurringDetailsRequest.recurring.contract': _contract
        'auth' :
          'user'    : config.adyen_users[_merchant_account].user
          'password': config.adyen_users[_merchant_account].password

      Q.nfcall(request.post, options)
      .then (http_response, body) ->
        res.send http_response
      .fail (err) ->
        log.ex err, "recurringDetails", "body: #{JSON.stringify body}"
        res.send '{status:"400", detail:"adyen error"}'
    catch err
      log.ex err, "recurringDetails", "body: #{JSON.stringify body}"
      res.send '{status:"400", detail:"adyen error"}'

  @getRecurringPayments: (req, res, next) ->
    log.i "getRecurringPayments"

    Q()
    .then ->
      reports.recurringPayments()
    .then (payments) ->
      res.send (payments)
    .fail (err) ->
      log.ex err, "getRecurringPayments", ""



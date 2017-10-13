Q          = require 'q'
costs      = require './cost_calculator'
service    = require './service'

mongo      = require '../dbs/mongo'

log        = require('../log').create 'Payment_utils'

@validateTripPayment = (rtaxi_id, from, to, payment_reference) ->
  log.i "validateTripPayment"

  payment_mongo = null

  Q()
  .then =>
    service.getAndCreateConfig(rtaxi_id)
  .then (config) =>
    #si no tiene viajes prepagos, cualquier pedido es válido
    unless config.has_mobile_payments and config.has_required_zone
      throw new Error "no prepayment"

    mongo.Payment.findOne
      reference: payment_reference
    .exec()
  .then (payment) ->
    log.d "#{payment_reference}: #{JSON.stringify payment}"
    if not payment?
      throw new Error "invalid payment reference: #{payment_reference}"

    payment_mongo = payment
    costs.calculateCost rtaxi_id, from, to
  .then (cost) ->
    cost_difference = payment_mongo.amount - cost
    payment_ok      = not payment_mongo.consumed and (-1 < cost_difference < 1)

    if payment_ok
      payment_mongo.consumed = true;

      payment_mongo.save()
    else
      log.e """CRITICAL Failed to validate trip. User:
               #{user_id}, payment data: #{JSON.stringify payment_mongo},
               cost: #{cost}. PAYMENT WAS PROCESSED BUT TRIP NOT DISPATCHED
          """

    return payment_ok

  .catch (err) ->
    unless err.message is "no prepayment"
      log.ex err, "validateTripPayment",
                  "user_id: #{user_id}, from: #{from}, to: #{to}, reference: #{payment_reference}",
                  "CRITICAL"

    #Si tenemos un error en este método, es mejor asumir que el pago estuvo bien
    #Si no devolvemos true, pueden no despacharse viajes pagos
    return true



@savePayment = (reference, merchant, environment, currency, amount, contract, http_response) ->
  log.d "savePayment #{JSON.stringify http_response}"

  payment = new mongo.Payment()
  payment.reference   = reference
  payment.merchant    = merchant
  payment.environment = environment
  payment.currency    = currency
  payment.amount      = amount
  payment.contract    = contract

  payment.status = "Error" if "Error" in JSON.stringify http_response
  payment.status = "Authorized" if "Authorized" in JSON.stringify http_response
  payment.status = "Rejected" if "Rejected" in JSON.stringify http_response

  if contract is "RECURRING"
    body = JSON.stringify http_response[0].body
    first = body.split(".pspReference=")[1]
    pspReference = first.split("&")[0]
    payment.pspReference = pspReference
    log.d pspReference

  payment.save()


Q          = require 'q'

config     = require '../../config'
service    = require '../tasks/service'
request    = require 'request'
DataStore   = require '../dbs/data_store'

log        = require('../log').create 'Zoho'

store = new DataStore

class @ZohoInvoice
  @zoho_url = "https://invoice.zoho.com/api/v3"

  @_token_to_customer_name: (admin_token) ->
    Q()
    .then ->
      store.getUserFromToken(admin_token)
    .then (user) =>
      log.d JSON.stringify user
      if user.type is "ar.com.goliath.Company" or user.type is "ar.com.goliath.CompanyAccount"
        Q()
        .then ->
          service.getAndCreateConfig(user.id)
        .then (config) ->
          return config.zoho
        .fail (err) ->
          log.ex err, "_token_to_customer_name"
      else return "NOTOKEN"
    .fail (err) ->
      log.ex err, "_token_to_customer_name"


  @list_invoices: (admin_token, res, next) ->
    log.i "list_invoices"

    Q()
    .then =>
      @_token_to_customer_name(admin_token)
    .then (customer_id) =>
      unless customer_id?
        throw new Error "INVALID_TOKEN"

      log.d "ID: #{customer_id}"
      options =
        'url' : "#{@zoho_url}/invoices",
        'qs' :
          'customer_id' : customer_id
          'authtoken'   : config.zoho_token

      Q.nfcall(request.get, options)
      .then (http_response, body) ->
        body = JSON.parse(http_response[0].body)
        if !body? or body.message != "success"
          res.send '{status:"400", detail:"zoho error"}'
        res.send body

      .fail (err) ->
        log.ex err, "list_invoices", "body: #{JSON.stringify body}"
        res.send '{status:"400", detail:"zoho error"}'
    .fail (err) ->
      log.ex err, "list_invoices", "body: #{JSON.stringify body}"
      res.send '{status:"400", detail:"zoho error"}'


  @invoice_with_id: (invoice_id, res, next) ->
    log.i "list_invoices"

    try
      options =
        'url' : "#{@zoho_url}/invoices/#{invoice_id}",
        'qs' :
          'authtoken'     : config.zoho_token

      Q.nfcall(request.get, options)
      .then (http_response, body) ->
        body = JSON.parse(http_response[0].body)
        if !body? or body.message != "success"
          res.send '{status:"400", detail:"zoho error"}'
        res.send body

      .fail (err) ->
        log.ex err, "list_invoices", "body: #{JSON.stringify body}"
        res.send '{status:"400", detail:"zoho error"}'
    catch err
      log.ex err, "list_invoices", "body: #{JSON.stringify body}"
      res.send '{status:"400", detail:"zoho error"}'

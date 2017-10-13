config    = require '../../config'
sendgrid  = require('sendgrid')(config.sendgrid.user,config.sendgrid.password)
Q         = require 'q'


@sendMail = (text) ->
  Q()
  .then =>
    data =
    {
      to:       'developers@technorides.com',
      from:     'no-reply@dinerotaxi.com',
      subject:  'Socket-error',
      text:     text
    }
    sendgrid.send data
  .then (res) =>
    console.log 'Sendgrid :: OK'
  .fail (err) =>
    console.log 'Sendgrid :: ERR - ' + err
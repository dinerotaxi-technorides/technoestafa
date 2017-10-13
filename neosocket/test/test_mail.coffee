expect    = require("chai").expect
log       = require('../src/log').create 'Test'

describe 'Send mail', ->
  it 'Error message', ->
     expect log.e 'This is an error mail test'

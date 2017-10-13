crypto = require 'crypto'
expect = require("chai").expect


describe 'SHA-256 test', ->
  it 'Obtain the hashed password', ->
    password=crypto.createHash('sha256').update('12345').digest('hex')
    console.log password
    expect password
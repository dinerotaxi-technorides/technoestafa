'use strict';

var winston = require('winston');
var util = require('util');
try {
  var newrelic = require('newrelic');
} catch(err) {
  var newrelic = undefined;
}
var NestedError = require('nested-error-stacks');

var Newrelic = module.exports = function() {
};

util.inherits(Newrelic, winston.Transport);
winston.transports.newrelic = Newrelic;

Newrelic.prototype.log = function(level, msg, meta, callback) {
  if(newrelic){
    if (level === 'error') {
      if(meta.nrTransaction)
        newrelic.setTransactionName(meta.nrTransaction);

      if(msg)
        newrelic.noticeError(new NestedError(msg, meta), meta.nrParams);
      else
        newrelic.noticeError(meta, meta.nrParams);
    }
  }

  callback(null, true);
};

module.exports = Newrelic;

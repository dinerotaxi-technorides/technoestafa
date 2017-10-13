'use strict';

const Random      = require('random-js'),
      Promise     = require('bluebird');

class TokenGenerator {

  constructor() {
    this._random = new Random();
  }

  next() {
    return Promise.try(() => this._random.string(64));
  }

}

module.exports = TokenGenerator;
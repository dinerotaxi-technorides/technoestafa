'use strict';

const crypto = require('crypto');

class PasswordEncoder {

  encode(raw_password) {
    return crypto.createHash('sha256').update(raw_password).digest('hex');
  }

  areEquals(raw_password, encoded_password) {
    return this.encode(raw_password) === encoded_password;
  }

}

module.exports = PasswordEncoder;
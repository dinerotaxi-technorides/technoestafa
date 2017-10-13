'use strict';

const Promise             = require("bluebird"),
  AuthenticationError = require('../../errors/AuthenticationError'),
  PasswordEncoder     = require('./PasswordEncoder'),
  intersect           = require('intersect');

class AuthenticationService {

  constructor(user_dao, roles_dao, tokens_dao, token_generator) {
    this._password_encoder = new PasswordEncoder();
    this._users = user_dao;
    this._roles = roles_dao;
    this._tokens = tokens_dao;
    this._token_generator = token_generator;
  }

  authenticateUser(username, password) {
    const allowed_authorities = [
      'ROLE_COMPANY', 'ROLE_ADMIN', 'ROLE_OPERATOR', 'ROLE_COMPANY_ACCOUNT', 'ROLE_COMPANY_ACCOUNT_EMPLOYEE',
      'ROLE_TELEPHONIST', 'ROLE_INVESTOR', 'ROLE_MONITOR'
    ];

    return this._users.findOneByUserName(username)
    .then(user => this._validateBasicData(user, password))
    .then(user => this._validateRoles(user, allowed_authorities))
    .then(user => this._generateToken(user))
  }

  authenticateBookingUser(username, password, company_username) {
    var user_promise;
    // authenticate as a company owner
    if(username === company_username)
      user_promise = this._users.findCompanyUserByUserName(username);
    // authenticate as a user (the user should belong to the company)
    else
      user_promise = this._users.findOneByUserNameAndCompanyName(username, company_username);

    return user_promise
    .then(user => this._validateBasicData(user, password))
    .then(user => this._generateToken(user))
  }

  authenticateDriverUser(username, password, company_username) {
    const allowed_authorities = [
      'ROLE_TAXI', 'ROLE_TAXI_OWNER'
    ];

    return this._users.findOneByUserNameAndCompanyName(username, company_username)
    .then(user => this._validateBasicData(user, password))
    .then(user => this._validateRoles(user, allowed_authorities))
    .then(user => this._generateToken(user))
  }

  authenticatePassenger(username, password, company_username) {
    return this._users.findOneByUserNameAndCompanyName(username, company_username)
    .then(user => this._validateBasicData(user, password))
    .then(user => this._generateToken(user))
  }

  /* ------------------------------------------------------------------
   PRIVATE HELPERS
   ------------------------------------------------------------------ */
  _generateToken(user) {
    return this._token_generator.next()
    .then(new_token => {
      this._tokens.insert(new_token, user.username, user.rtaxi_id);
      return new_token;
    });
  }

  _validateBasicData(usr, password) {
    if (!usr) throw new AuthenticationError(411, "Invalid credentials");
    if (!this._password_encoder.areEquals(password, usr.password)) throw new AuthenticationError(411, "Invalid credentials");
    if (!usr.enabled) throw new AuthenticationError(412, "User is disabled");
    if (usr.account_expired) throw new AuthenticationError(413, "This account is disabled");
    if (usr.account_locked) throw new AuthenticationError(414, "This account is locked");
    if (usr.password_expired) throw new AuthenticationError(415, "The password has expired");

    return usr;
  }

  _validateRoles(user, allowed_authorities) {
    return this._roles.findAllByUserId(user.id)
    .then(roles => roles.map(r => r.authority))
    .then(authorities => {
      if(intersect(authorities, allowed_authorities).length == 0) throw new AuthenticationError(416, "The user does not have the right roles");
      return user;
    });
  }

}

module.exports = AuthenticationService;
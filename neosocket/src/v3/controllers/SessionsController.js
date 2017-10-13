'use strict';

const Promise             = require('bluebird'),
      AuthenticationError = require('../errors/AuthenticationError'),
      logger              = require('../../log'),
      BaseController      = require('./BaseController');

class SessionsController extends BaseController{

  constructor(authenticationService, login_api_translator) {
    super();
    this._authenticationService = authenticationService;
    this._translator = login_api_translator;
  }

  login(req, res, next) {
    var body;
    return Promise.try(() => {
      // validates the parameters
      if(!req.query.json) throw new AuthenticationError(409, "The body is required");
      body = JSON.parse(req.query.json);
      if(!body.email || body.email.trim() === "") throw new AuthenticationError(410, "Email required");

      // try to authenticate using the service
      return this._authenticationService.authenticateUser(body.email, body.password);
    })
    .then(token => this._translator.translateToTechnoRidesLoginApi(body.email, token))
    .then(legacy_api => res.json(legacy_api))
    .catch(err => this._handleAuthenticationError(res, err));
  }

  bookingLogin(req, res, next) {
    var body;
    Promise.try(() => {
      // validates the parameters
      if(!req.query.json) throw new AuthenticationError(409, "The body is required");
      body = JSON.parse(req.query.json);
      if(!body.email || body.email.trim() === "") throw new AuthenticationError(410, "Email required");
      if(!body.rtaxi || body.rtaxi.trim() === "") throw new AuthenticationError(410, "Rtaxi required");

      // try to authenticate using the service
      return this._authenticationService.authenticateBookingUser(body.email, body.password, body.rtaxi);
    })
    .then(token => this._translator.translateToTechnoRidesBookingLoginApi(body.email, token))
    .then(legacy_api => res.json(legacy_api))
    .catch(err => this._handleAuthenticationError(res, err));
  }

  driverLogin(req, res, next) {
    var body;
    Promise.try(() => {
      // validates the parameters
      if(!req.query.json) throw new AuthenticationError(409, "The body is required");
      body = JSON.parse(req.query.json);
      if(!body.email || body.email.trim() === "") throw new AuthenticationError(410, "Email required");
      if(!body.rtaxi || body.rtaxi.trim() === "") throw new AuthenticationError(410, "Rtaxi required");

      // try to authenticate using the service
      return this._authenticationService.authenticateDriverUser(body.email, body.password, body.rtaxi);
    })
    .then(token => this._translator.translateToUsersTaxistaApiLogin(body.email, token))
    .then(legacy_api => res.json(legacy_api))
    .catch(err => this._handleAuthenticationError(res, err));
  }

  passengerLogin(req, res, next) {
    var body;
    Promise.try(() => {
      // validates the parameters
      if(!req.query.json) throw new AuthenticationError(409, "The body is required");
      body = JSON.parse(req.query.json);
      if(!body.email || body.email.trim() === "") throw new AuthenticationError(410, "Email required");
      if(!body.rtaxi || body.rtaxi.trim() === "") throw new AuthenticationError(410, "Rtaxi required");

      // try to authenticate using the service
      return this._authenticationService.authenticatePassenger(body.email, body.password, body.rtaxi);
    })
    .then(token => this._translator.translateToUsersApiLogin(body.email, token))
    .then(legacy_api => res.json(legacy_api))
    .catch(err => this._handleAuthenticationError(res, err));
  }
}


module.exports = SessionsController;
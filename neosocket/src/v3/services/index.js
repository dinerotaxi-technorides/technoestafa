'use strict';

const AuthenticationService   = require('./security/AuthenticationService'),
      OperationService        = require('./OperationService'),
      TokenService            = require('./TokenService'),
      UserService             = require('./UserService'),
      BusinessModelService    = require('./BusinessModelService'),
      DeviceService           = require('./DeviceService'),
      TripService             = require('./TripService'),
      TokenGenerator          = require('./security/TokenGenerator');

const daos = require('../daos');

module.exports = {
  authentication: new AuthenticationService(daos.users, daos.roles, daos.tokens, new TokenGenerator()),
  operations    : new OperationService(daos.operations, daos.track_operations),
  tokens        : new TokenService(daos.tokens),
  users         : new UserService(daos.users),
  businessModel : new BusinessModelService(daos.business_model),
  device        : new DeviceService(daos.devices),
  trips         : new TripService(new OperationService, daos.places, daos.favorites)
};
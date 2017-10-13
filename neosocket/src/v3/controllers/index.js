'use strict';

const services             = require('../services'),
      daos                 = require('../daos'),
      SessionsController   = require('./SessionsController'),
      OperationsController = require('./OperationsController'),
      LoginApiTranslator   = require('./translators/legacy/LoginApiTranslator');

var login_api_translator = new LoginApiTranslator(daos.users, daos.configs, daos.cities, daos.roles, daos.business_model, daos.cost_centers, daos.vehicles);

module.exports = {
  sessions: new SessionsController(services.authentication, login_api_translator),
  operations: new OperationsController(services.users, services.tokens, services.businessModel, services.device, services.operations, services.trips)
};

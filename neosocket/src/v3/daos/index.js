'use strict';

const UsersDao            = require('./UsersDao'),
      RolesDao            = require('./RolesDao'),
      TokensDao           = require('./TokensDao'),
      ConfigsDao          = require('./ConfigsDao'),
      CitiesDao           = require('./CitiesDao'),
      BusinessModelDao    = require('./BusinessModelDao'),
      CostCentersDao      = require('./CostCentersDao'),
      VehiclesDao         = require('./VehiclesDao'),
      OperationsDao       = require('./OperationsDao'),
      TrackOperationsDao  = require('./TrackOperationsDao'),
      DeviceDao           = require('./DeviceDao'),
      DelayOperationDao   = require('./DelayOperationDao'),
      FavoritesDao        = require('./FavoritesDao'),
      PlacesDao           = require('./PlacesDao')

const config = require('../../../config');
const knex = require('knex')(
              {
                client: 'mysql',
                connection: config.mysql,
                pool: {
                  min: config.mysql_pool.min,
                  max: config.mysql_pool.max
                },
                debug: false
              }
);

module.exports = {
  users            : new UsersDao(),
  roles            : new RolesDao(knex),
  tokens           : new TokensDao(),
  configs          : new ConfigsDao(),
  cities           : new CitiesDao(),
  business_model   : new BusinessModelDao(knex),
  cost_centers     : new CostCentersDao(),
  vehicles         : new VehiclesDao(knex),
  operations       : new OperationsDao(),
  track_operations : new TrackOperationsDao(),
  devices          : new DeviceDao(knex),
  delay_operation  : new DelayOperationDao(),
  favorites        : new FavoritesDao(),
  places           : new PlacesDao()
};
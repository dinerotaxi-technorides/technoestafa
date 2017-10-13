'use strict';

const models = require('../../models_sequelize');

class TrackOperationsDao {

  insert(operation) {
    return models.track_operation.create(operation);
  }

}

module.exports = TrackOperationsDao;
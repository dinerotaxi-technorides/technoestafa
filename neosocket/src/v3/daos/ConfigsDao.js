'use strict';

const models = require('../../models_sequelize');

class ConfigsDao {

  findOneById(id) {
    return models.configuration_app.findOne({where: { id: id }});
  }

}

module.exports = ConfigsDao;
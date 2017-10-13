'use strict';

const models = require('../../models_sequelize');

class CitiesDao {

  findOneById(id) {
    return models.enabled_cities.findOne({where: { id: id }});
  }

}

module.exports = CitiesDao;
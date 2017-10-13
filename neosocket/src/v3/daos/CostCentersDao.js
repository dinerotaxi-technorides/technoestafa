'use strict';

const models = require('../../models_sequelize');

class CostCentersDao {

  findOneById(id) {
    return models.cost_center.findOne({where: { id: id }});
  }

}

module.exports = CostCentersDao;
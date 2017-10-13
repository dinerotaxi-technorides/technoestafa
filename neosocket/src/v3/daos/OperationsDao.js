'use strict';

const models = require('../../models_sequelize');

class OperationsDao {

  constructor(knex){
    this._knex = knex;
  }

  insert(operation) {
    return models.operation.create(operation);
  }

  findAllByUserIdAndStatus(user_id, status){
    return this._knex
        .select(
            '*'
        )
        .from('operation')
        .whereNotIn('id', status)
        .andWhere('user_id', user_id);
  }

}

module.exports = OperationsDao;
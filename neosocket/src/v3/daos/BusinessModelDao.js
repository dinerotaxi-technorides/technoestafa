'use strict';

class BusinessModelDao {

  constructor(knex) {
    this._knex = knex;
  }

  findAllByUserId(user_id) {
    return this._knex
      .select(
        'business_model.*'
      )
      .from('user_business_model')
      .innerJoin('business_model', 'business_model.id', 'user_business_model.business_model_id')
      .where('user_business_model.user_id', user_id);
  }

}

module.exports = BusinessModelDao;
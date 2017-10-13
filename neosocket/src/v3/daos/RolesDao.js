'use strict';

class RolesDao {

  constructor(knex) {
    this._knex = knex;
  }

  findAllByUserId(user_id) {
    return this._knex
      .select(
        'role.*'
      )
      .from('user_role')
      .innerJoin('role', 'user_role.role_id', 'role.id')
      .where('user_role.user_id', user_id);
  }

}

module.exports = RolesDao;
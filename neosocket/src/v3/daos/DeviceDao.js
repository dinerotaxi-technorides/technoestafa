'use strict';

const models = require('../../models_sequelize');

class DeviceDao {

    constructor(knex) {
        this._knex = knex;
    }

    insert(device) {
        return models.device.create(device);
    }

    findAllByUserId(user_id) {
        return this._knex
            .select(
                'role.*'
            )
            .from('device')
            .where('user_id', user_id);
    }

    deleteAllByUserId(user_id){
        return this._knex('device')
            .where('user_id', user_id)
            .del();
    }

}

module.exports = DeviceDao;
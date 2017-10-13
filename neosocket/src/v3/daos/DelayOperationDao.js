'use strict';

const models = require('../../models_sequelize');

class DelayOperationDao {

    insert(operation) {
        return models.delay_operation.create(operation);
    }

}

module.exports = DelayOperationDao;
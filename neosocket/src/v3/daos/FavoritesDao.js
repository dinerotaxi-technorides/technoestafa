'use strict';

const models = require('../../models_sequelize');

class FavoritesDao {

    insert(operation) {
        return models.temporal_favorites.create(operation);
    }

}

module.exports = FavoritesDao;
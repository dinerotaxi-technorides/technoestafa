'use strict';

const models = require('../../models_sequelize');

class PlacesDao {

    insert(place) {
        return models.place.create(place);
    }

}

module.exports = PlacesDao;
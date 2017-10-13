'use strict';

const business_model  = require('../utils/business_model');

class BusinessModelService {

    constructor(businessModel_dao) {
        this._businessModel = businessModel_dao;
    }

    /*
     @parameters:
     usr [User]
     */
    findOneByUser(usr) {
        var bizModel = usr.businessModel[0];
        return bizModel?bizModel:business_model.GENERIC;
    }

    /*
     @parameters:
     usr_id
     */
    findAllByUserId(user_id){
        var bizModel;
        if(user_id) bizModel = this._businessModel.findAllByUserId(user_id);
        return bizModel;
    }
}

module.exports = BusinessModelService;
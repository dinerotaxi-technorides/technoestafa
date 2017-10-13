'use strict';

const business_model  = require('../utils/business_model'),
      StringUtils     = require('../utils/StringUtil');

class UserService {

    constructor(user_dao) {
        this._users = user_dao;
    }

    /*
     @parameters:
     username
     rtaxi
     */
    findByUsernameAndRtaxi(username, rtaxi){
        var user;
        if(!username && !rtaxi) user = this._users.findOneByUserNameAndCompanyId(username, rtaxi);
        return user;
    }

    /*
     @parameters:
     user_id
     */
    findCompanyUserByUserId(user_id){
        var company;
        if(!user_id && !user_id) company = this._users.findCompanyUserByUserId(user_id);
        return company;
    }

    /*
     @parameters:
     id
     */
    findOneById(id){
        var user;
        if(!id) user = this._users.findOneById(id);
        return user;
    }

    /*
     @parameters:
     usr
     */
    getBusiness(usr) {
        return usr.businessModel[0]?bs.name:business_model.GENERIC;
    }

    /*
     @parameters:
     user [User]
     */
    isValidUser(user){
        if (StringUtils.isBlank(user)) throw new ValidationError(411, "The user not exists");
        if (StringUtils.isBlank(user.email)) throw new ValidationError(1, "The user mail not exists");
        if (StringUtils.isBlank(user.enabled)) throw new ValidationError(412, "The user is not enabled");
        if (user.accountExpired) throw new ValidationError(413, "The user account has expired");
        if (user.accountLocked) throw new ValidationError(414, "The user account is locked");
        if (user.passwordExpired) throw new ValidationError(415, "The user password has expired");
    }
}

module.exports = UserService;
'use strict';

const models = require('../../models_sequelize'),
      legacy_utils = require('../utils/legacy_utils');

class UsersDao {


  findOneById(id) {
    return models.user.findOne({where: { id: id }});
  }

  findOneByUserName(username) {
    return models.user.findOne({where: { username: username }});
  }

  findCompanyUserByUserName(username) {
    return models.user.findOne({where: { username: username, class: legacy_utils.getUserCompanyClazz() }});
  }

  findCompanyUserByUserId(user_id) {
    return models.user.findOne({where: { id: user_id, class: legacy_utils.getUserCompanyClazz() }});
  }

  findOneByUserNameAndCompanyId(username, company_id) {
    return models.user.findOne({where: { username: username, rtaxi_id: company_id }});
  }

  findOneByUserNameAndCompanyName(username, company_username) {
    return this.findCompanyUserByUserName(company_username)
    .then(company => {
      if(company) return this.findOneByUserNameAndCompanyId(username, company.id)
      else return;
    });
  }
}

module.exports = UsersDao;
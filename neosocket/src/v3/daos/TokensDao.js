'use strict';

const models = require('../../models_sequelize'),
      Random = require('random-js');

class TokensDao {

  constructor() {
    this._random = new Random();
  }

  insert(token, username, rtaxi) {
    var series = this._random.string(64);

    models.persistent_logins.destroy({ where: { username: username, rtaxi: rtaxi } });

    return models.persistent_logins.create({
      series        : series,
      created_date  : new Date(),
      last_used     : new Date(),
      token         : token,
      username      : username,
      rtaxi         : rtax
    });
  }

  findOneByToken(token){
    return models.persistent_logins.findOne({where: { token: token }});
  }
}

module.exports = TokensDao;
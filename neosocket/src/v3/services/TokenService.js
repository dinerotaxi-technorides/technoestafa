'use strict';

class TokenService {

    constructor(token_dao) {
        this._tokens = token_dao;
    }

    /*
     @parameters:
     token
     */
    findOneByToken(token) {
        var token;
        if(!token) token = this._tokens.findOneByToken(token);
        return token;
    }
}

module.exports = TokenService;
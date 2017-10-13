'use strict';

const  logger = require('../../log');

class BaseController{

    /* ---------------------------------------------------------------------
     -                          PRIVATE HELPERS
     - --------------------------------------------------------------------- */
    _handleAuthenticationError(res, err){
        if(err.name == 'AuthenticationError') res.json({ status: err.code, msg: err.message });
        if(err.name == 'ValidationError') res.json({ status: err.code, msg: err.message });
        else throw err;
    }
}

module.exports = BaseController;
'use strict';

const logger              = require('../../log');

module.exports = (err, req, res, next) => {
  logger.error(err.message, err);
  res
    .status(500)
    .json({
        status: 500,
        msg:'internal server error, our best engineers are (probably) trying to solve the issue.'
    });
};
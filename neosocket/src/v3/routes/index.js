'use strict';

const router        = require('express-promise-router')(),
      controllers   = require('../controllers');

router.get('/technoRidesLoginApi/login', (req, res, next) => controllers.sessions.login(req, res, next));
router.get('/technoRidesBookingLoginApi', (req, res, next) => controllers.sessions.bookingLogin(req, res, next));
router.get('/usersTaxistaApi/login', (req, res, next) => controllers.sessions.driverLogin(req, res, next));
router.get('/usersApi/login', (req, res, next) => controllers.sessions.passengerLogin(req, res, next));


module.exports = router;

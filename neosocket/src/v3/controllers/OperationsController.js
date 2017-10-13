'use strict';

const Promise             = require('bluebird'),
      ValidationError     = require('../errors/ValidationError'),
      logger              = require('../../log'),
      BaseController      = require('./BaseController'),
      StringUtil          = require('../utils/StringUtil');


class OperationsController extends BaseController{

    constructor(userService, tokenService, businessModelService, deviceService, operationService, tripService){
        super();
        this._tokenService         = tokenService;
        this._userService          = userService;
        this._businessModelService = businessModelService;
        this._deviceService        = deviceService;
        this._operationService     = operationService;
        this._tripService          = tripService;
    }

    bookingCreateTrip(req, res, next){
      var body, user;

      // validate the body
      Promise.try(() => {
          if (!req.query.json) throw new ValidationError(409, "The body is required");

          body = JSON.parse(req.query.json);

          // validate input parameter
          this._validateParameters(body);
          return this._tokenService.findOneByToken(body.token)
      })
      .then(rs => {
         var token = rs;
         if(!token) throw new ValidationError(415, "The token is not recorder in DB");
         return this._userService.findByUsernameAndRtaxi(token.username, token.rtaxi?token.rtaxi:null);
      })
      .then(rs => {
         user = rs;
         this._userService.isValidUser(user);
         return this._deviceService.deleteAllByUserId(user.id);
      })
      .then(() => [
         this._deviceService.setDeviceToUser(user.id),
         this._operationService.checkOperationForUser(user.id),
         this._userService.findCompanyUserByUserId(user.rtaxi.id)
      ])
      .spread((rs_device, rs_operation, rs_company) => {
          //If Company accept only one trip creation
          if (!StringUtil.isBlank(rs_company) && rs_company.wlconfig.blockMultipleTrips){
              Promise.all(() => {
                 StringUtil.isBlank(businessModel)?this._businessModelService.findOneByUser(user):body.businessModel;
              })
              .then(businessModel =>
                 this._tripService.createBookingTrip(
                    user,
                    {
                      'business_model': businessModel,
                      'from': body.address_from,
                      'to': body.address_to,
                      'preferneces' : body.options,
                      'comments' : body.comments
                    },
                    rs_device,
                    body.driver_number,
                    null,
                    body.payment_reference,
                    body.amount))
              .then(operartion => {
                  res.status(200);
                  res.json({
                      status: 100,
                      opId: operations[0],
                      opList: operations,
                      countTrip: body.count_trip
                  });
              });
          }else{
              //Otherwhise returns a default message
              res.json({
                  status    : 100,
                  opId      : rs_operation.id,
                  opList    : rs_operation,
                  countTrip : body.count_trip,
                  error     : "Activated Option only one trip per customer!!"
              });
          }

      })
      .catch(err => this._handleAuthenticationError(res, err));
    }

    bookingProgrammedTrip(req, res, next){

    }


    /* ---------------------------------------------------------------------
     -                          PRIVATE HELPERS
     - --------------------------------------------------------------------- */

    _validateParameters(body){
        if (StringUtil.isBlank(body.token)) throw new ValidationError(410, "Token required");
        if (StringUtil.isBlank(body.addressFrom)) throw new ValidationError(411, "AddressFrom required");
        if (StringUtil.isBlank(body.options)) throw new ValidationError(413, "Options required");
        if (StringUtil.isBlank(body.device)) throw new ValidationError(414, "Device required");
    }
}

module.exports = OperationsController;
'use strict';

const legacy_utils      = require('../utils/legacy_utils'),
      operation_status  = require('../utils/operation_status');

class OperationService {
  constructor(operations_dao, track_operations_dao) {
    this._operations        = operations_dao;
    this._track_operations  = track_operations_dao;
  }

  /*
     @parameters:
        passenger [User]
        business_model [String] --> GENERIC|TAXI|LIMO|SHUTTLE|DELIVERY
        itinerary [TemporalFavorites]
        preferences [Options]
        device [String] --> IPHONE|WEB|ANDROID|BB
        driver_number [String]
        middle_man [User]
        payment_reference [String]
        amount [Double]
  */
  createOperation(passenger, business_model, itinerary, preferences, device, driver_number, middle_man, payment_reference, amount) {
    return this._cost_centers.findOneById(passenger.cost_center_id)
    .then(cost_center => {
      return this._operations.insert({
        company_id          : passenger.rtaxi_id,
        created_date        : new Date(),
        dev                 : device,
        enabled             : true,
        intermediario_id    : middle_man.id,
        is_test_user        : passenger.is_test_user,
        last_modified_date  : new Date(),
        status              : operation_status.INITIAL_STATUS,
        user_id             : passenger.id,
        class               : legacy_utils.getOperationPendingClass(),
        amount              : amount,
        is_company_account  : !legacy_utils.isRealUser(passenger.class),
        options_id          : preferences.id,
        send_to_socket      : false,
        driver_number       : driver_number,
        payment_reference   : payment_reference,
        corporate_id        : cost_center.corporate_id,
        cost_center_id      : cost_center.id,
        created_by_operator : true,
        ip                  : "0.0.0.0",
        is_delay_operation  : false,
        business_model      : business_model,
        favorite_id         : itinerary.id
      })
      .then(operation => {
        return this._track_operations.insert({
          created_date        : new Date(),
          oepration_id        : operation.id,
          status              : operation.status,
          is_company_account  : operation.is_company_account
        });

        return operation;
      });
    });
  }

  /*
   @parameters:
   user_id
   */
  checkOperationForUser(user_id){
    var operation;
    if(user_id) operation = this._operations.findAllByUserIdAndStatus(user_id,  operation_status.NOT_COMPLETED);
    return operation;
  }
}

module.exports = OperationService;
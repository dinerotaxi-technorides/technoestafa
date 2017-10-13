'use strict';

const config        = require('../../../../../config'),
      legacy_utils  = require('../../../utils/legacy_utils');

class LoginApiTranslator {

  constructor(users_dao, configs_dao, cities_dao, roles_dao, business_model_dao, cost_centers_dao, vehicles_dao) {
    this._users = users_dao;
    this._configs = configs_dao;
    this._cities = cities_dao;
    this._roles = roles_dao;
    this._business_model = business_model_dao;
    this._cost_centers = cost_centers_dao;
    this._vehicles = vehicles_dao;
  }

  translateToTechnoRidesLoginApi(username, token) {
    var user, company;

    return this._users.findOneByUserName(username)
    .then(rs => user = rs)
    .then(() => {
      if(user.rtaxi_id) return this._users.findOneById(user.rtaxi_id);
      else return user;
    })
    .then(rs => company = rs)
    .then(() => [
      this._findCompanyConfig(company.wlconfig_id),
      this._cities.findOneById(user.city_id),
      this._roles.findAllByUserId(user.id),
      this._business_model.findAllByUserId(user.id)
    ])
    .spread((company_config, city, roles, business_models) => {
      return {
        email             : username,
        host              : username.split("@")[1],
        token             : token,
        package_company   : company_config.package_company,
        driver_quota      : company_config.driver_quota,
        status            : 100,
        lang              : user.lang,
        latitude          : company.latitude || 0,
        longitude         : company.longitude || 0,
        country           : city.country,
        time_zone         : city.time_zone,
        admin_code        : city.admin1code,
        country_code      : city.country_code,
        id                : user.id,
        is_required_zone  : company_config.has_required_zone,
        use_admin_code    : company_config.use_admin_code,
        first_name        : user.first_name,
        last_name         : user.last_name,
        company           : company.company_name,
        rtaxi             : user.rtaxi_id,
        roles             : roles.map(r => r.authority).join(","),
        digitalRadio      : company_config.digital_radio,
        map_key           : company_config.map_key,
        operatorDispatchMultipleTrips : company_config.operator_dispatch_multiple_trips,
        is_chat_enabled               : company_config.is_chat_enabled,
        is_fare_calculator_enabled    : company_config.is_fare_calculator_active,
        credit_card_enable            : company_config.credit_card_enable,
        operatorSuggestDestination    : company_config.operator_dispatch_multiple_trips,
        operatorCancelationReason     : company_config.operator_cancelation_reason,
        blockMultipleTrips            : company_config.block_multiple_trips,
        businessModel                 : business_models.map(bm => bm.name),
        showBusinessModel             : business_models.length > 1,
        isPrePaidActive               : company_config.is_pre_paid_active
      };
    });
  }

  translateToTechnoRidesBookingLoginApi(username, token) {

    var user, company;

    return this._users.findOneByUserName(username)
      .then(rs => user = rs)
      .then(() => {
        if(user.rtaxi_id) return this._users.findOneById(user.rtaxi_id);
        else return user;
      })
      .then(rs => company = rs)
      .then(() => [
        this._findCompanyConfig(company.wlconfig_id),
        this._cities.findOneById(user.city_id),
        this._roles.findAllByUserId(user.id),
        this._business_model.findAllByUserId(user.id),
        this._cost_centers.findOneById(user.cost_center_id)
      ])
      .spread((company_config, city, roles, business_models, cost_center) => {
        return {
          email             : username,
          host              : username.split("@")[1],
          token             : token,
          status            : 100,
          lang              : user.lang,
          latitude          : company.latitude || 0,
          longitude         : company.longitude || 0,
          country           : city.country,
          time_zone         : city.time_zone,
          admin_code        : city.admin1code,
          driver_quota      : company_config.driver_quota,
          package_company   : company_config.package_company,
          country_code      : city.country_code,
          id                : user.id,
          is_required_zone  : company_config.has_required_zone,
          use_admin_code    : company_config.use_admin_code,
          first_name        : user.first_name,
          last_name         : user.last_name,
          company           : company.company_name,
          rtaxi             : user.rtaxi_id,
          roles             : roles.map(r => r.authority).join(","),
          digitalRadio      : company_config.digital_radio,
          map_key           : company_config.map_key,
          operatorDispatchMultipleTrips : company_config.operator_dispatch_multiple_trips,
          is_chat_enabled               : company_config.is_chat_enabled,
          is_fare_calculator_enabled    : company_config.is_fare_calculator_active,
          credit_card_enable            : company_config.credit_card_enable,
          operatorSuggestDestination    : company_config.operator_dispatch_multiple_trips,
          operatorCancelationReason     : company_config.operator_cancelation_reason,
          blockMultipleTrips            : company_config.block_multiple_trips,
          businessModel                 : business_models.map(bm => bm.name),
          showBusinessModel             : business_models.length > 1,
          isPrePaidActive               : company_config.is_pre_paid_active,
          googleApiKey      : company_config.booking_map_key,
          companyPhone      : company.phone,
          had_driver_number : company_config.had_user_number,
          currency          : company_config.mobile_currency || config.default_currency,
          has_mobile_payment: false,
          merchant_id       : company_config.merchant_id,
          rtaxiId           : company.id,
          is_cc             : legacy_utils.isUserCorporate(user.class),
          is_cc_admin       : user.admin,
          is_cc_super_admin : user.corporate_super_user,
          cost_id           : user.cost_center_id,
          corporate_id      : cost_center ? cost_center.id : undefined,
          phone             : user.phone
        };
      });
  }

  translateToUsersTaxistaApiLogin(username, token) {

    var user, company;

    return this._users.findOneByUserName(username)
      .then(rs => user = rs)
      .then(() => {
        if(user.rtaxi_id) return this._users.findOneById(user.rtaxi_id);
        else return user;
      })
      .then(rs => company = rs)
      .then(() => [
        this._findCompanyConfig(company.wlconfig_id),
        this._cities.findOneById(user.city_id),
        this._roles.findAllByUserId(user.id),
        this._business_model.findAllByUserId(user.id),
        this._cost_centers.findOneById(user.cost_center_id),
        this._vehicles.findOneByDriverId(user.id).then(vehicle => vehicle || {})
      ])
      .spread((company_config, city, roles, business_models, cost_center, vehicle) => {
        return {
          driver_quota      : company_config.driver_quota,
          package_company   : company_config.package_company,
          token             : token,
          status            : 100,
          lang              : user.lang,
          lat               : company.latitude || 0,
          lng               : company.longitude || 0,
          companyPhone      : company.phone,
          country           : city.country,
          adminCode         : city.admin1code,
          use_admin_code    : company_config.use_admin_code,
          countryCode       : city.country_code,
          id                : user.id,
          firstName         : user.first_name,
          lastName          : user.last_name,
          phone             : user.phone,
          plate             : vehicle.patente,
          brandCompany      : vehicle.marca,
          model             : vehicle.modelo,
          rtaxiId           : company.id,
          poolingTrip       : company_config.interval_pooling_trip * 1000,
          driverCancellationReason    : company_config.driver_cancellation_reason,
          poolingTripInTransaction    : company_config.interval_pooling_trip_in_transaction * 1000,
          hadPaymentRequired          : company_config.has_driver_payment,
          hadUserNumber               : company_config.had_user_number,
          has_mobile_payment          : company_config.has_mobile_payment,
          has_required_zone           : company_config.has_zone_active,
          is_chat_enabled             : company_config.is_chat_enabled,
          digitalRadio      : company_config.digital_radio,
          currency          : company_config.mobile_currency || config.default_currency,
          newOpshowAddressFrom        : company_config.new_opshow_address_from,
          newOpshowAddressTo          : company_config.new_opshow_address_to,
          newOpshowCorporate          : company_config.new_opshow_corporate,
          newOpshowUserName           : company_config.new_opshow_user_name,
          newOpshowOptions            : company_config.new_opshow_options,
          newOpshowUserPhone          : company_config.new_opshow_user_phone,
          newOpComment                : company_config.new_op_comment,
          isProfileEditable : company_config.drivers_profile_editable,
          isQueueTripActivated        : company_config.is_queue_trip_activated,
          disputeTimeTrip             : company_config.dispute_time_trip,
          driverShowScheduleTrips     : company_config.driver_show_schedule_trips,
          hasDriverDispatcherFunction : company_config.has_driver_dispatcher_function,
          isFareCalculatorActive      : company_config.is_fare_calculator_active,
          creditCardEnable            : company_config.credit_card_enable,
          isPrePaidActive             : company_config.is_pre_paid_active,
          isCorporate                 : user.is_corporate,
          isMessaging                 : user.is_messaging,
          isPet                       : user.is_pet,
          isAirConditioning           : user.is_air_conditioning,
          isSmoker                    : user.is_smoker,
          isSpecialAssistant          : user.is_special_assistant,
          isLuggage                   : user.is_luggage,
          isAirport                   : user.is_airport,
          isVip                       : user.is_vip,
          isInvoice                   : user.is_invoice,
          isRegular                   : user.is_regular,

          fareInitialCost             : company_config.fare_initial_cost,
          fareCostPerKm               : company_config.fare_cost_per_km,
          fareConfigActivateTimePerDistance : company_config.fare_config_activate_time_per_distance,
          fareConfigGracePeriodMeters : company_config.fare_config_grace_period_meters,
          fareConfigGraceTime         : company_config.fare_config_grace_time,
          fareConfigTimeSecWait       : company_config.fare_config_time_sec_wait,
          fareConfigTimeInitialSecWait: company_config.fare_config_time_initial_sec_wait,
          fareCostTimeWaitPerXSeg     : company_config.fare_cost_time_wait_perxseg,
          fareCostTimeInitialSecWait  : company_config.fare_cost_time_initial_sec_wait,
          distanceType                : company_config.distance_type,
          googleApiKey      : company_config.booking_map_key,
          additionals       : [],
          businessModel     : business_models.map(bm => bm.name)
        };
      });
  }

  translateToUsersApiLogin(username, token) {

    var user, company;

    return this._users.findOneByUserName(username)
      .then(rs => user = rs)
      .then(() => {
        if(user.rtaxi_id) return this._users.findOneById(user.rtaxi_id);
        else return user;
      })
      .then(rs => company = rs)
      .then(() => [
        this._findCompanyConfig(company.wlconfig_id),
        this._cities.findOneById(user.city_id),
        this._roles.findAllByUserId(user.id),
        this._business_model.findAllByUserId(user.id),
        this._cost_centers.findOneById(user.cost_center_id),
        this._vehicles.findOneByDriverId(user.id).then(vehicle => vehicle || {})
      ])
      .spread((company_config, city, roles, business_models, cost_center, vehicle) => {
        return {
          googleApiKey      : company_config.booking_map_key,
          token             : token,
          status            : 100,
          lat               : city.north_east_lat_bound,
          lng               : city.north_east_lng_bound,
          companyPhone      : company.phone,
          lang              : user.lang,
          country           : city.country,
          time_zone         : city.time_zone,
          admin_code        : city.admin1code,
          useAdminCode      : company_config.use_admin_code,
          had_driver_number : company_config.had_user_number,
          country_code      : city.country_code,
          id                : user.id,
          currency          : company_config.mobile_currency || config.default_currency,
          isFareCalculatorActive      : company_config.is_fare_calculator_active,
          creditCardEnable            : company_config.credit_card_enable,
          has_mobile_payment :false,
          merchant_id       : company_config.merchant_id,
          rtaxiId           : company.id,
          is_cc             : legacy_utils.isUserCorporate(user.class),
          is_cc_admin       : user.admin,
          is_cc_super_admin : user.corporate_super_user,
          cost_id           : user.cost_center_id,
          corporate_id      : cost_center ? cost_center.id : undefined,
          is_required_zone  : company_config.has_required_zone,
          firstName         : user.first_name,
          lastName          : user.last_name,
          phone             : user.phone,
          email             : username,
          businessModel     : business_models.map(bm => bm.name),
          roles             : roles.map(r => r.authority)
        };
      });
  }

  _findCompanyConfig(wlconfig_id) {
    return this._configs.findOneById(wlconfig_id)
    .then(company_config => {
      company_config = company_config ||{};

      // set de default map key if it's not in the company configuration table.
      if(company_config.map_key == "" || !company_config.map_key){
        company_config.map_key = config.google_maps.key;
        company_config.booking_map_key = config.google_maps.booking_key;
      } else {
        company_config.booking_map_key = company_config.map_key;
      }

      return company_config;
    })
  }

}

module.exports = LoginApiTranslator;
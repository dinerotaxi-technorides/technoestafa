'use strict';

const Promise = require('bluebird')

const legacy_utils  = require('../utils/legacy_utils');

class TripService {

  constructor(operation_service, places_dao, favorites_dao) {
    this._operation_service = operation_service;
    this._places = places_dao;
    this._favorites = favorites_dao;
  }

  /*
   @parameters:
     passenger [User]
     itinerary [Object]
         {
           business_model [String] --> GENERIC|TAXI|LIMO|SHUTTLE|DELIVERY
           from [Object]
               {
                  number
                  street
                  city
                  country
                  ccode
                  lng
                  lat
               }
           to [Object]
               {
                 number
                 street
                 city
                 country
                 ccode
                 lng
                 lat
               }
           preferences [Options]
           comments [String]
         }
     device [String] --> IPHONE|WEB|ANDROID|BB
     driver_number [String]
     middle_man [User]
     payment_reference [String]
     amount [Double]
   */
  createTrip(passenger, itinerary, device, driver_number, middle_man, payment_reference, amount) {
    return Promise.all([
      this._insertPlace(itinerary.from),
      this._insertPlace(itinerary.to)
    ])
    .spread((from, to) =>
      this._favorites.insert({
        name                : itinerary.from.street + " " + itinerary.from.number,
        created_date        : new Date(),
        user_id             : passenger.id,
        comments            : itinerary.comments,
        enabled             : true,
        place_from_id       : from.id,
        place_to_id         : to ? to.id : undefined,
        place_from_pso      : itinerary.from.floor,
        place_from_dto      : itinerary.from.apartment,
        place_to_floor      : itinerary.to ? itinerary.to.floor : undefined,
        place_to_apartment  : itinerary.to ? itinerary.to.apartment : undefined,
        class               : legacy_utils.getTemporalFavoritesClass()
      })
    )
    .then(temporal_favorite => this._operation_service.createOperation(passenger, itinerary.business_model, temporal_favorites, itinerary.preferences, device, driver_number, middle_man, payment_reference, amount));
  }

    /*
     @parameters:
     passenger [User]
     itinerary [Object]
     {
        business_model [String] --> GENERIC|TAXI|LIMO|SHUTTLE|DELIVERY
        from [Object]
        {
            number
             street
             city
             country
             ccode
             lng
             lat
        }
        to [Object]
        {
            number
             street
             city
             country
             ccode
             lng
             lat
        }
        preferences [Options]
        comments [String]
     }
     device [String] --> IPHONE|WEB|ANDROID|BB
     driver_number [String]
     middle_man [User]
     payment_reference [String]
     amount [Double]
     */
  createBookingTrip(passenger, itinerary, device, driver_number, middle_man, payment_reference, amount) {
    var operations = [];

    //Generate multiple trips and returns each operation id
    for (i = 0; i < body.count_trip; i++) {
        operations.push(
            this.createTrip(
                passenger,
                itinerary,
                device,
                driver_number,
                middle_man,
                payment_reference,
                amount
            ).oepration_id
        );
    }

    return operations;
  }


    /*
      {
         number
         street
         city
         country
         ccode
         lng
         lat
       }
     */
  _insertPlace(form) {
    if(!form) return;

    var json = {
      name                : form.number + ' ' + form.street + ',' + form.city + ',' + form.country,
      lat                 : form.lat,
      lng                 : form.lng,
      northEastLatBound   : -34.5627767697085,
      northEastLngBound   : -58.47518266970849,
      southWestLatBound   : -34.5654747302915,
      southWestLngBound   : -58.47788063029145,
      country             : form.country,
      countryCode         : form.country,
      locality            : form.city,
      admin2Code          : "",
      admin3Code          : "",
      street              : form.street,
      streetNumber        : form.number,
      postalCode          : "",
      locationType        : "RANGE_INTERPOLATED",
      type                : "street_address",
      latlng              : { "$a": -34.5641195,  "ab": -58.476537199999996 },
      viewport: {
        aa: {
          b:  -34.5654747302915,
          j:  -34.5627767697085
        },
        ba: {
          b:  -58.47788063029145,
          j:  -58.47518266970849
        }
      }
    };

    return this._places.insert({
      json                    : JSON.stringify(json), //FIXME en realidad esto seria lo que habria que persistir en la DB, no habria que guardar un JSON en una columna.
      lat                     : json.lat,
      lng                     : json.lng,
      location_type           : json.locationType,
      north_east_lat_bound    : json.northEastLatBound,
      north_east_lng_bound    : json.northEastLngBound,
      postal_code             : json.postalCode,
      south_west_lat_bound    : json.southWestLatBound,
      south_west_lng_bound    : json.southWestLngBound,
      street_number           : json.streetNumber,
      type                    : json.type
    });
  }

}

module.exports = TripService;
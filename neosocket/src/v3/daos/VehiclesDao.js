'use strict';

class VehiclesDao {

  constructor(knex) {
    this._knex = knex;
  }

  findOneByDriverId(user_id) {
    return this._knex
      .select(
        'vehicle.*'
      )
      .from('vehicle_employ_user')
      .innerJoin('vehicle', 'vehicle.id', 'vehicle_employ_user.vehicle_taxistas_id')
      .where('vehicle_employ_user.employ_user_id', user_id)
      .then(list => {
        if(list.length > 0) return list[0];
        else return;
      });
  }

}

module.exports = VehiclesDao;
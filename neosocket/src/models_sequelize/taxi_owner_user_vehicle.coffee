### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'taxi_owner_user_vehicle', {
    taxi_owner_user_vehicles_id:
      type: DataTypes.BIGINT
      allowNull: true
    vehicle_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'taxi_owner_user_vehicle'
  }

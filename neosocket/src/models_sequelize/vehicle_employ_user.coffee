### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'vehicle_employ_user', {
    vehicle_taxistas_id:
      type: DataTypes.BIGINT
      allowNull: true
    employ_user_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'vehicle_employ_user'
  }

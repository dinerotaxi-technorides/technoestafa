### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'real_user_place', {
    real_user_places_id:
      type: DataTypes.BIGINT
      allowNull: true
    place_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'real_user_place'
  }

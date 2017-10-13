### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'place', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    json:
      type: DataTypes.TEXT
      allowNull: false
    lat:
      type: 'DOUBLE'
      allowNull: false
    lng:
      type: 'DOUBLE'
      allowNull: false
    location_type:
      type: DataTypes.STRING
      allowNull: true
    north_east_lat_bound:
      type: 'DOUBLE'
      allowNull: false
    north_east_lng_bound:
      type: 'DOUBLE'
      allowNull: false
    postal_code:
      type: DataTypes.STRING
      allowNull: true
    south_west_lat_bound:
      type: 'DOUBLE'
      allowNull: false
    south_west_lng_bound:
      type: 'DOUBLE'
      allowNull: false
    street_number:
      type: DataTypes.STRING
      allowNull: true
    type:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'place'
  }

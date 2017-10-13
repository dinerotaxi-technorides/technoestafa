### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'enabled_cities', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    admin1code:
      type: DataTypes.STRING
      allowNull: true
    country:
      type: DataTypes.STRING
      allowNull: true
    country_code:
      type: DataTypes.STRING
      allowNull: false
    enabled:
      type: DataTypes.BOOLEAN

      allowNull: false
    locality:
      type: DataTypes.STRING
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    north_east_lat_bound:
      type: DataTypes.FLOAT
      allowNull: true
    north_east_lng_bound:
      type: DataTypes.FLOAT
      allowNull: true
    south_west_lat_bound:
      type: DataTypes.FLOAT
      allowNull: true
    south_west_lng_bound:
      type: DataTypes.FLOAT
      allowNull: true
    time_zone:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'enabled_cities'
  }

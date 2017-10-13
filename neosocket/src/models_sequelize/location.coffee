### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'location', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    alternate_names:
      type: DataTypes.STRING
      allowNull: true
    city:
      type: DataTypes.STRING
      allowNull: true
    country:
      type: DataTypes.STRING
      allowNull: true
    countrycode:
      type: DataTypes.STRING
      allowNull: true
    county:
      type: DataTypes.STRING
      allowNull: true
    destination_id:
      type: DataTypes.BIGINT
      allowNull: true
    east:
      type: 'DOUBLE'
      allowNull: false
    lat:
      type: 'DOUBLE'
      allowNull: false
    line1:
      type: DataTypes.STRING
      allowNull: true
    line2:
      type: DataTypes.STRING
      allowNull: true
    line3:
      type: DataTypes.STRING
      allowNull: true
    line4:
      type: DataTypes.STRING
      allowNull: true
    lng:
      type: 'DOUBLE'
      allowNull: false
    name:
      type: DataTypes.STRING
      allowNull: false
    north:
      type: 'DOUBLE'
      allowNull: false
    parent_id:
      type: DataTypes.BIGINT
      allowNull: true
    postal:
      type: DataTypes.STRING
      allowNull: true
    radius:
      type: 'DOUBLE'
      allowNull: false
    south:
      type: 'DOUBLE'
      allowNull: false
    state:
      type: DataTypes.STRING
      allowNull: true
    street:
      type: DataTypes.STRING
      allowNull: true
    type:
      type: DataTypes.STRING
      allowNull: false
    west:
      type: 'DOUBLE'
      allowNull: false
    woeid:
      type: DataTypes.INTEGER(11)
      allowNull: false
    woetype:
      type: DataTypes.INTEGER(11)
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'location'
  }

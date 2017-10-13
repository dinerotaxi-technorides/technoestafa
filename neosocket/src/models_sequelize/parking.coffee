### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'parking', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    lat:
      type: 'DOUBLE'
      allowNull: true
    lng:
      type: 'DOUBLE'
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
    coordinates_in:
      type: DataTypes.TEXT
      allowNull: true
    coordinates_out:
      type: DataTypes.TEXT
      allowNull: true
    is_polygon:
      type: DataTypes.BOOLEAN

      allowNull: false
    business_model:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'parking'
  }

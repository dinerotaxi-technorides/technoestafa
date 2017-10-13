### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'options', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    air_conditioning:
      type: DataTypes.BOOLEAN

      allowNull: false
    luggage:
      type: DataTypes.BOOLEAN

      allowNull: false
    messaging:
      type: DataTypes.BOOLEAN

      allowNull: false
    pet:
      type: DataTypes.BOOLEAN

      allowNull: false
    smoker:
      type: DataTypes.BOOLEAN

      allowNull: false
    special_assistant:
      type: DataTypes.BOOLEAN

      allowNull: false
    airport:
      type: DataTypes.BOOLEAN

      allowNull: false
    invoice:
      type: DataTypes.BOOLEAN

      allowNull: false
    vip:
      type: DataTypes.BOOLEAN

      allowNull: false
  }, {
    timestamps: false,
    tableName: 'options'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'shippers', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    active:
      type: DataTypes.BOOLEAN

      allowNull: false
    name:
      type: DataTypes.STRING
      allowNull: false
    phone:
      type: DataTypes.STRING
      allowNull: false
    phone1:
      type: DataTypes.STRING
      allowNull: true
    phone2:
      type: DataTypes.STRING
      allowNull: true
    x:
      type: DataTypes.FLOAT
      allowNull: false
    y:
      type: DataTypes.FLOAT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'shippers'
  }

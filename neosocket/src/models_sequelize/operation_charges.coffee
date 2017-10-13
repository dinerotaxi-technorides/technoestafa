### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'operation_charges', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    charge:
      type: 'DOUBLE'
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    json:
      type: DataTypes.STRING
      allowNull: false
    name:
      type: DataTypes.STRING
      allowNull: false
    operation_id:
      type: DataTypes.BIGINT
      allowNull: false
    type_charge:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'operation_charges'
  }

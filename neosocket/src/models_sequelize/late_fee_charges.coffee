### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'late_fee_charges', {
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
    config_id:
      type: DataTypes.BIGINT
      allowNull: false
      references:
        model: 'late_fee_config'
        key: 'id'
    frequency:
      type: DataTypes.INTEGER(11)
      allowNull: false
    name:
      type: DataTypes.STRING
      allowNull: false
    type_charge:
      type: DataTypes.INTEGER(11)
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'late_fee_charges'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'late_fee_config', {
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
    name:
      type: DataTypes.STRING
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    frequency:
      type: DataTypes.INTEGER(11)
      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    rtaxi_id:
      type: DataTypes.BIGINT
      allowNull: false
    type_charge:
      type: DataTypes.INTEGER(11)
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'late_fee_config'
  }

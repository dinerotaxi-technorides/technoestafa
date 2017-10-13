### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'pre_paid_driver_payment', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    amount:
      type: 'DOUBLE'
      allowNull: false
    amount_unused:
      type: 'DOUBLE'
      allowNull: false
    payment_date:
      type: DataTypes.DATE
      allowNull: true
    status:
      type: DataTypes.STRING
      allowNull: false
    driver_id:
      type: DataTypes.BIGINT
      allowNull: true
    payment_mode:
      type: DataTypes.STRING
      allowNull: false
    notes:
      type: DataTypes.STRING
      allowNull: true
    reference:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'pre_paid_driver_payment'
  }

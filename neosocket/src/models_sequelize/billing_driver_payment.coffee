### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'billing_driver_payment', {
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
    bank_charges:
      type: 'DOUBLE'
      allowNull: true
    notes:
      type: DataTypes.STRING
      allowNull: true
    payment_date:
      type: DataTypes.DATE
      allowNull: true
    payment_mode:
      type: DataTypes.STRING
      allowNull: false
    reference:
      type: DataTypes.STRING
      allowNull: true
    send_email:
      type: DataTypes.BOOLEAN

      allowNull: false
    tax_deducted:
      type: DataTypes.BOOLEAN

      allowNull: true
  }, {
    timestamps: false,
    tableName: 'billing_driver_payment'
  }

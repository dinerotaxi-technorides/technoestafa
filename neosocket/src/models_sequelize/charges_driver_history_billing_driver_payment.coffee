### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'charges_driver_history_billing_driver_payment', {
    charges_driver_history_payments_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'charges_driver_history'
        key: 'id'
    billing_driver_payment_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'billing_driver_payment'
        key: 'id'
  }, {
    timestamps: false,
    tableName: 'charges_driver_history_billing_driver_payment'
  }

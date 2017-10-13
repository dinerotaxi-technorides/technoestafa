### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'billing_enterprise_history_billing_payments', {
    billing_enterprise_history_payments_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'billing_enterprise_history'
        key: 'id'
    billing_payments_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'billing_payments'
        key: 'id'
  }, {
    timestamps: false,
    tableName: 'billing_enterprise_history_billing_payments'
  }

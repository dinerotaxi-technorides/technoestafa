### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'billing_payments', {
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
      allowNull: false
    notes:
      type: DataTypes.STRING
      allowNull: false
    payment_date:
      type: DataTypes.DATE
      allowNull: false
    payment_mode:
      type: DataTypes.STRING
      allowNull: false
    reference:
      type: DataTypes.STRING
      allowNull: false
    send_email:
      type: DataTypes.BOOLEAN

      allowNull: false
    tax_deducted:
      type: DataTypes.BOOLEAN

      allowNull: false
  }, {
    timestamps: false,
    tableName: 'billing_payments'
  }

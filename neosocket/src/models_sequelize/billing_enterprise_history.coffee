### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'billing_enterprise_history', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    adjustment:
      type: 'DOUBLE'
      allowNull: true
    billing_date:
      type: DataTypes.DATE
      allowNull: false
    cost_center_id:
      type: DataTypes.BIGINT
      allowNull: false
      references:
        model: 'cost_center'
        key: 'id'
    created_date:
      type: DataTypes.DATE
      allowNull: true
    customer_notes:
      type: DataTypes.STRING
      allowNull: true
    due_date:
      type: DataTypes.DATE
      allowNull: false
    invoice_id:
      type: DataTypes.STRING
      allowNull: false
    late_fee_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'late_fee_charges'
        key: 'id'
    status:
      type: DataTypes.STRING
      allowNull: false
    sub_total:
      type: 'DOUBLE'
      allowNull: false
    term_charges_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'term_charges'
        key: 'id'
    total:
      type: 'DOUBLE'
      allowNull: false
    discount:
      type: 'DOUBLE'
      allowNull: false
    discount_percentage:
      type: 'DOUBLE'
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'billing_enterprise_history'
  }

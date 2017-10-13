### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'item_detail_enterprise', {
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
    discount:
      type: 'DOUBLE'
      allowNull: true
    discount_type:
      type: DataTypes.INTEGER(11)
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    operation_id:
      type: DataTypes.BIGINT
      allowNull: false
    quantity:
      type: DataTypes.INTEGER(11)
      allowNull: false
    tax_charge_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'tax_charges'
        key: 'id'
  }, {
    timestamps: false,
    tableName: 'item_detail_enterprise'
  }

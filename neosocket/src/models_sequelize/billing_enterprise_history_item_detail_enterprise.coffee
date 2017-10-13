### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'billing_enterprise_history_item_detail_enterprise', {
    billing_enterprise_history_items_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'billing_enterprise_history'
        key: 'id'
    item_detail_enterprise_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'item_detail_enterprise'
        key: 'id'
  }, {
    timestamps: false,
    tableName: 'billing_enterprise_history_item_detail_enterprise'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'charges_driver_history_item_detail_driver', {
    charges_driver_history_items_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'charges_driver_history'
        key: 'id'
    item_detail_driver_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'item_detail_driver'
        key: 'id'
  }, {
    timestamps: false,
    tableName: 'charges_driver_history_item_detail_driver'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'catalog_order_details', {
    order_details_id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
    catalog_id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
  }, {
    timestamps: false,
    tableName: 'catalog_order_details'
  }

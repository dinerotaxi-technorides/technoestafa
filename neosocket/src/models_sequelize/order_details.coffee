### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'order_details', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    bil_date:
      type: DataTypes.DATE
      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    discount:
      type: DataTypes.BOOLEAN

      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    orders_id:
      type: DataTypes.BIGINT
      allowNull: true
    price:
      type: 'DOUBLE'
      allowNull: true
    product_id:
      type: DataTypes.BIGINT
      allowNull: false
    quantity:
      type: DataTypes.INTEGER(11)
      allowNull: true
    ship_date:
      type: DataTypes.DATE
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'order_details'
  }

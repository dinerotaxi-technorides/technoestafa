### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'product', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    category_id:
      type: DataTypes.BIGINT
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    description:
      type: DataTypes.STRING
      allowNull: false
    discount:
      type: 'DOUBLE'
      allowNull: true
    discount_availble:
      type: DataTypes.BOOLEAN

      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    note:
      type: DataTypes.STRING
      allowNull: false
    product_available:
      type: DataTypes.BOOLEAN

      allowNull: false
    quantity_per_unit:
      type: DataTypes.INTEGER(11)
      allowNull: false
    ranking:
      type: DataTypes.INTEGER(11)
      allowNull: true
    unit_price:
      type: 'DOUBLE'
      allowNull: false
    unit_stock:
      type: DataTypes.INTEGER(11)
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'product'
  }

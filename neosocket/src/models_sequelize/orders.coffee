### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'orders', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    deleted:
      type: DataTypes.BOOLEAN

      allowNull: false
    device_id:
      type: DataTypes.BIGINT
      allowNull: false
    err_loc:
      type: DataTypes.STRING
      allowNull: true
    err_msg:
      type: DataTypes.STRING
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    order_date:
      type: DataTypes.DATE
      allowNull: true
    payment_method_id:
      type: DataTypes.BIGINT
      allowNull: true
    sales_tax:
      type: DataTypes.DATE
      allowNull: true
    ship_date:
      type: DataTypes.DATE
      allowNull: true
    shipper_id:
      type: DataTypes.BIGINT
      allowNull: true
    total:
      type: 'DOUBLE'
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'orders'
  }

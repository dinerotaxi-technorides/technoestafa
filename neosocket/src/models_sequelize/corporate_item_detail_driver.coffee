### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'corporate_item_detail_driver', {
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
    charges_date:
      type: DataTypes.DATE
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    discount:
      type: 'DOUBLE'
      allowNull: true
    discount_type:
      type: DataTypes.INTEGER(11)
      allowNull: true
    driver_id:
      type: DataTypes.BIGINT
      allowNull: false
    operation_id:
      type: DataTypes.BIGINT
      allowNull: false
    paid_date:
      type: DataTypes.DATE
      allowNull: true
    rtaxi_id:
      type: DataTypes.BIGINT
      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
    sub_total:
      type: 'DOUBLE'
      allowNull: true
    total:
      type: 'DOUBLE'
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'corporate_item_detail_driver'
  }

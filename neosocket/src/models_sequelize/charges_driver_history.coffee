### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'charges_driver_history', {
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
    customer_notes:
      type: DataTypes.STRING
      allowNull: true
    driver_id:
      type: DataTypes.BIGINT
      allowNull: false
    due_date:
      type: DataTypes.DATE
      allowNull: false
    invoice_id:
      type: DataTypes.STRING
      allowNull: false
    rtaxi_id:
      type: DataTypes.BIGINT
      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
    sub_total:
      type: 'DOUBLE'
      allowNull: false
    total:
      type: 'DOUBLE'
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'charges_driver_history'
  }

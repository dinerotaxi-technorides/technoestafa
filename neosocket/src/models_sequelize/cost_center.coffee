### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'cost_center', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    corporate_id:
      type: DataTypes.BIGINT
      allowNull: false
      references:
        model: 'corporate'
        key: 'id'
    invoice_period:
      type: DataTypes.INTEGER(11)
      allowNull: false
      defaultValue: '1'
    legal_address:
      type: DataTypes.STRING
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: true
    phone:
      type: DataTypes.STRING
      allowNull: true
    rtaxi_id:
      type: DataTypes.BIGINT
      allowNull: false
    visible:
      type: DataTypes.BOOLEAN

      allowNull: false
      defaultValue: false
  }, {
    timestamps: false,
    tableName: 'cost_center'
  }

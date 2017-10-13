### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'corporate', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    cuit:
      type: DataTypes.STRING
      allowNull: false
    legal_address:
      type: DataTypes.STRING
      allowNull: false
    logotype:
      type: 'MEDIUMBLOB'
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    phone:
      type: DataTypes.STRING
      allowNull: false
    phone1:
      type: DataTypes.STRING
      allowNull: true
    rtaxi_id:
      type: DataTypes.BIGINT
      allowNull: false
    visible:
      type: DataTypes.BOOLEAN

      allowNull: false
    fare_calculato_discount:
      type: DataTypes.INTEGER(11)
      allowNull: false
    discount:
      type: DataTypes.INTEGER(11)
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'corporate'
  }

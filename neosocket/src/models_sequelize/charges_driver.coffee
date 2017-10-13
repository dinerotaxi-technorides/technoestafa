### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'charges_driver', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    amount:
      type: DataTypes.DECIMAL
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: false
    description:
      type: DataTypes.STRING
      allowNull: true
    driver_payment:
      type: DataTypes.INTEGER(11)
      allowNull: false
    enabled:
      type: DataTypes.BOOLEAN

      allowNull: false
    expiration_date:
      type: DataTypes.DATE
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'charges_driver'
  }

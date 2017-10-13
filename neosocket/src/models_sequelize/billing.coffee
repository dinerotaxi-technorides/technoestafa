### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'billing', {
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
    billing_date:
      type: DataTypes.DATE
      allowNull: false
    comments:
      type: DataTypes.STRING
      allowNull: true
    hadpaid:
      type: DataTypes.BOOLEAN

      allowNull: false
    recive:
      type: DataTypes.STRING
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'billing'
  }

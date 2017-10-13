### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'customer', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    age:
      type: DataTypes.INTEGER(11)
      allowNull: true
    email_address:
      type: DataTypes.STRING
      allowNull: true
    first_name:
      type: DataTypes.STRING
      allowNull: false
    last_name:
      type: DataTypes.STRING
      allowNull: false
    other_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'customer'
  }

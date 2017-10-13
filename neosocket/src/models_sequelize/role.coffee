### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'role', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    authority:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'role'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'foo', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'foo'
  }

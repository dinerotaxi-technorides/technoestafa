### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'tags', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    name:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'tags'
  }

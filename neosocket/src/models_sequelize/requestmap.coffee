### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'requestmap', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    config_attribute:
      type: DataTypes.STRING
      allowNull: false
    url:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'requestmap'
  }

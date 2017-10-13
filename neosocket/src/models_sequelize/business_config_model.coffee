### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'business_config_model', {
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
    tableName: 'business_config_model'
  }

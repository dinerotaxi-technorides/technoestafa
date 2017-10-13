### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'business_model_config_params', {
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
    tableName: 'business_model_config_params'
  }

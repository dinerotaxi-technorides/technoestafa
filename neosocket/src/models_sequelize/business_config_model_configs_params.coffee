### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'business_config_model_configs_params', {
    configs_params:
      type: DataTypes.BIGINT
      allowNull: true
    configs_params_idx:
      type: DataTypes.STRING
      allowNull: true
    configs_params_elt:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'business_config_model_configs_params'
  }

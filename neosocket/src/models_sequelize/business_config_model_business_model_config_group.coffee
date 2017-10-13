### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'business_config_model_business_model_config_group', {
    business_config_model_group_config_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'business_config_model'
        key: 'id'
    business_model_config_group_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'business_model_config_group'
        key: 'id'
  }, {
    timestamps: false,
    tableName: 'business_config_model_business_model_config_group'
  }

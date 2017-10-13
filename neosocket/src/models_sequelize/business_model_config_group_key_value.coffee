### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'business_model_config_group_key_value', {
    key_value:
      type: DataTypes.BIGINT
      allowNull: true
    key_value_idx:
      type: DataTypes.STRING
      allowNull: true
    key_value_elt:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'business_model_config_group_key_value'
  }

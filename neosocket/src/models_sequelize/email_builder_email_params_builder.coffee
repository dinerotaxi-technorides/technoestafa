### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'email_builder_email_params_builder', {
    email_builder_params_builder_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'email_builder'
        key: 'id'
    email_params_builder_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'email_params_builder'
        key: 'id'
  }, {
    timestamps: false,
    tableName: 'email_builder_email_params_builder'
  }

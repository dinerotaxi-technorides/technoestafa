### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'billing_enterprise_history_user', {
    billing_enterprise_history_email_to_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'billing_enterprise_history'
        key: 'id'
    user_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'billing_enterprise_history_user'
  }

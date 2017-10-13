### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user_business_model', {
    business_model_id:
      type: DataTypes.BIGINT
      allowNull: false
      references:
        model: 'business_model'
        key: 'id'
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
  }, {
    timestamps: false,
    tableName: 'user_business_model'
  }

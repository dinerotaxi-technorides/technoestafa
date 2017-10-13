### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'employ_user_profile_builder', {
    employ_user_profile_variables_id:
      type: DataTypes.BIGINT
      allowNull: true
    profile_builder_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'profile_builder'
        key: 'id'
  }, {
    timestamps: false,
    tableName: 'employ_user_profile_builder'
  }

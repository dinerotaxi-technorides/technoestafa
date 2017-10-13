### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user_role', {
    role_id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
  }, {
    timestamps: false,
    tableName: 'user_role'
  }

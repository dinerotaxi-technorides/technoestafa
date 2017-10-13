### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'facebook_user', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    access_token:
      type: DataTypes.STRING
      allowNull: false
    uid:
      type: DataTypes.BIGINT
      allowNull: false
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'facebook_user'
  }

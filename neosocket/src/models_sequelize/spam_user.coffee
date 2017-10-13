### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'spam_user', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    spam_id:
      type: DataTypes.BIGINT
      allowNull: false
      references:
        model: 'spam'
        key: 'id'
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'spam_user'
  }

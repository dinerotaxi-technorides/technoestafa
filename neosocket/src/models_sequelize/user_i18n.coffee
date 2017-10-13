### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user_i18n', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    description:
      type: DataTypes.TEXT
      allowNull: true
    lang:
      type: DataTypes.STRING
      allowNull: false
    tagline:
      type: DataTypes.STRING
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'user_i18n'
  }

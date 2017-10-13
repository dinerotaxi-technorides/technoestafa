### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'email_builder', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    body:
      type: DataTypes.TEXT
      allowNull: false
    date_created:
      type: DataTypes.DATE
      allowNull: false
    is_enabled:
      type: DataTypes.BOOLEAN

      allowNull: false
    lang:
      type: DataTypes.STRING
      allowNull: false
    last_updated:
      type: DataTypes.DATE
      allowNull: false
    name:
      type: DataTypes.STRING
      allowNull: false
    subject:
      type: DataTypes.STRING
      allowNull: false
    user_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'email_builder'
  }

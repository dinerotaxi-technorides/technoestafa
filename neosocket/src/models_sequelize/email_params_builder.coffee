### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'email_params_builder', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    name:
      type: DataTypes.STRING
      allowNull: false
    value:
      type: DataTypes.TEXT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'email_params_builder'
  }

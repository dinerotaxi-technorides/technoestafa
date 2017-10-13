### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'audit', {
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
    email:
      type: DataTypes.STRING
      allowNull: true
    ip:
      type: DataTypes.STRING
      allowNull: false
    json_params:
      type: DataTypes.TEXT
      allowNull: true
    page:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'audit'
  }

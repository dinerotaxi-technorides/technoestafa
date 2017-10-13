### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'device', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    description:
      type: DataTypes.STRING
      allowNull: true
    dev:
      type: DataTypes.STRING
      allowNull: false
    key_value:
      type: DataTypes.STRING
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'device'
  }

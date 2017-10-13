### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'payment', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    allowed:
      type: DataTypes.BOOLEAN

      allowNull: false
    type:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'payment'
  }

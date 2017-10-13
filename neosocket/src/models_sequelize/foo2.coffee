### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'foo2', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    estado:
      type: DataTypes.STRING
      allowNull: false
    estado_envio:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'foo2'
  }

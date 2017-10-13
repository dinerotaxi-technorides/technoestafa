### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'auditoria_batch', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    accion:
      type: DataTypes.STRING
      allowNull: false
    detalle:
      type: DataTypes.TEXT
      allowNull: false
    fecha_log:
      type: DataTypes.DATE
      allowNull: true
    nombre_objeto:
      type: DataTypes.STRING
      allowNull: false
    status:
      type: DataTypes.BOOLEAN

      allowNull: false
    usuario:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'auditoria_batch'
  }

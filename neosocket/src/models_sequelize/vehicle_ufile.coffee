### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'vehicle_ufile', {
    vehicle_documents_id:
      type: DataTypes.BIGINT
      allowNull: true
    ufile_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'vehicle_ufile'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'profile', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    file_payload:
      type: 'LONGBLOB'
      allowNull: true
    usr_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'profile'
  }

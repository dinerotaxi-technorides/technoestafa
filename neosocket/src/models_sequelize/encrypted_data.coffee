### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'encrypted_data', {
    id:
      type: DataTypes.STRING
      allowNull: false
      primaryKey: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    data_item:
      type: DataTypes.TEXT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'encrypted_data'
  }

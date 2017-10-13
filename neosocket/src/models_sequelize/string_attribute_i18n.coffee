### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'string_attribute_i18n', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    lang:
      type: DataTypes.STRING
      allowNull: false
    string_attribute_id:
      type: DataTypes.BIGINT
      allowNull: false
    value:
      type: DataTypes.TEXT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'string_attribute_i18n'
  }

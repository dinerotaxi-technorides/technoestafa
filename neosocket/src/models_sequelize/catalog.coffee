### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'catalog', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    description:
      type: DataTypes.TEXT
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    parent_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'catalog'
  }

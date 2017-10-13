### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'category', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    active:
      type: DataTypes.BOOLEAN

      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    description:
      type: DataTypes.STRING
      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'category'
  }

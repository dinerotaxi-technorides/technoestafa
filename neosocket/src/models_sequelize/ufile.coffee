### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'ufile', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    date_uploaded:
      type: DataTypes.DATE
      allowNull: false
    downloads:
      type: DataTypes.INTEGER(11)
      allowNull: false
    extension:
      type: DataTypes.STRING
      allowNull: false
    name:
      type: DataTypes.STRING
      allowNull: false
    path:
      type: DataTypes.STRING
      allowNull: false
    size:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'ufile'
  }

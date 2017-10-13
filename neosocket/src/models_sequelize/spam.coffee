### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'spam', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    dev:
      type: DataTypes.STRING
      allowNull: false
    had_runing:
      type: DataTypes.BOOLEAN

      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    maxx:
      type: DataTypes.INTEGER(11)
      allowNull: true
    msj:
      type: DataTypes.TEXT
      allowNull: true
    type:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'spam'
  }

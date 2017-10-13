### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'comment', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    body:
      type: DataTypes.TEXT
      allowNull: false
    date_created:
      type: DataTypes.DATE
      allowNull: false
    last_updated:
      type: DataTypes.DATE
      allowNull: false
    poster_class:
      type: DataTypes.STRING
      allowNull: false
    poster_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'comment'
  }

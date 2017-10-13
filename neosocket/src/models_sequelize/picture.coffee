### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'picture', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    caption:
      type: DataTypes.STRING
      allowNull: false
    content_type:
      type: DataTypes.STRING
      allowNull: false
    date_created:
      type: DataTypes.DATE
      allowNull: false
    filename:
      type: DataTypes.STRING
      allowNull: false
    height:
      type: DataTypes.INTEGER(11)
      allowNull: false
    last_updated:
      type: DataTypes.DATE
      allowNull: false
    width:
      type: DataTypes.INTEGER(11)
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'picture'
  }

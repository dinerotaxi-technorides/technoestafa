### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'picture_link', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    picture_id:
      type: DataTypes.BIGINT
      allowNull: false
    picture_ref:
      type: DataTypes.BIGINT
      allowNull: false
    type:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'picture_link'
  }

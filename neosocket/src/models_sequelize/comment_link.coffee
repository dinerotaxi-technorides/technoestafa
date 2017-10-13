### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'comment_link', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    comment_id:
      type: DataTypes.BIGINT
      allowNull: false
    comment_ref:
      type: DataTypes.BIGINT
      allowNull: false
    type:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'comment_link'
  }

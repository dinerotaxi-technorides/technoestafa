### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'tag_links', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    tag_id:
      type: DataTypes.BIGINT
      allowNull: false
    tag_ref:
      type: DataTypes.BIGINT
      allowNull: false
    type:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'tag_links'
  }

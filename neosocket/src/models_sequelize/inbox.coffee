### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'inbox', {
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
    sender:
      type: DataTypes.STRING
      allowNull: false
    has_star:
      type: DataTypes.BOOLEAN

      allowNull: false
    last_updated:
      type: DataTypes.DATE
      allowNull: false
    rtaxi_id:
      type: DataTypes.BIGINT
      allowNull: false
    subject:
      type: DataTypes.STRING
      allowNull: false
    trashed:
      type: DataTypes.BOOLEAN

      allowNull: false
    was_readed:
      type: DataTypes.BOOLEAN

      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'inbox'
  }

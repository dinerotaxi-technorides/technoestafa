### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'mail_queue', {
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
    last_updated:
      type: DataTypes.DATE
      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
    subject:
      type: DataTypes.STRING
      allowNull: false
    receiver:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'mail_queue'
  }

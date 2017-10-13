### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'notification', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    alert_type:
      type: DataTypes.STRING
      allowNull: true
    app:
      type: DataTypes.STRING
      allowNull: false
    argss_as_string:
      type: DataTypes.STRING
      allowNull: false
    badge:
      type: DataTypes.INTEGER(11)
      allowNull: true
    code_device:
      type: DataTypes.STRING
      allowNull: true
    device_type:
      type: DataTypes.STRING
      allowNull: true
    email:
      type: DataTypes.STRING
      allowNull: true
    expired:
      type: DataTypes.DATE
      allowNull: true
    message:
      type: DataTypes.TEXT
      allowNull: true
    message_id:
      type: DataTypes.BIGINT
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: true
    operation_id:
      type: DataTypes.BIGINT
      allowNull: true
    retries:
      type: DataTypes.INTEGER(11)
      allowNull: false
    subject:
      type: DataTypes.STRING
      allowNull: true
    type:
      type: DataTypes.STRING
      allowNull: false
    user_id:
      type: DataTypes.BIGINT
      allowNull: true
    is_encoded:
      type: DataTypes.BOOLEAN

      allowNull: false
    code:
      type: DataTypes.INTEGER(11)
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'notification'
  }

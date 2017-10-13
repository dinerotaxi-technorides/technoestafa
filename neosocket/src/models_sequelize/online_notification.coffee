### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'online_notification', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    args:
      type: DataTypes.TEXT
      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    has_encoded:
      type: DataTypes.BOOLEAN

      allowNull: false
    is_read:
      type: DataTypes.BOOLEAN

      allowNull: false
    message:
      type: DataTypes.TEXT
      allowNull: false
    operation:
      type: DataTypes.BIGINT
      allowNull: true
    title:
      type: DataTypes.STRING
      allowNull: false
    usr_id:
      type: DataTypes.BIGINT
      allowNull: false
    is_for_company:
      type: DataTypes.BOOLEAN

      allowNull: false
  }, {
    timestamps: false,
    tableName: 'online_notification'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'connection_request', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    date_created:
      type: DataTypes.DATE
      allowNull: false
    from_user_id:
      type: DataTypes.BIGINT
      allowNull: false
    message:
      type: DataTypes.STRING
      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
    to_user_id:
      type: DataTypes.BIGINT
      allowNull: true
    to_user_email:
      type: DataTypes.STRING
      allowNull: false
    token:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'connection_request'
  }

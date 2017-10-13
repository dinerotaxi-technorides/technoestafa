### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'registration_code', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    date_created:
      type: DataTypes.DATE
      allowNull: false
    token:
      type: DataTypes.STRING
      allowNull: false
    username:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'registration_code'
  }

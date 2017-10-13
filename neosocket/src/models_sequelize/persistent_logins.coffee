### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'persistent_logins', {
    series:
      type: DataTypes.STRING
      allowNull: false
      primaryKey: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    last_used:
      type: DataTypes.DATE
      allowNull: false
    token:
      type: DataTypes.STRING
      allowNull: false
    username:
      type: DataTypes.STRING
      allowNull: false
    rtaxi:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'persistent_logins'
  }

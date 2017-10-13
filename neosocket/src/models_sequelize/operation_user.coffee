### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'operation_user', {
    operation_who_cancel_trip_id:
      type: DataTypes.BIGINT
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'operation_user'
  }

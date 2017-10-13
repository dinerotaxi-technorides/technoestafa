### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'black_list_radio_taxi_operation', {
    operation_id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'black_list_radio_taxi_operation'
  }

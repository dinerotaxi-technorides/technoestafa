### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'online_radio_taxi', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    company_id:
      type: DataTypes.BIGINT
      allowNull: false
    count_taxi:
      type: DataTypes.BIGINT
      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: false
    penality:
      type: DataTypes.BIGINT
      allowNull: true
    position:
      type: DataTypes.BIGINT
      allowNull: true
    status:
      type: DataTypes.STRING
      allowNull: false
    time_effort:
      type: DataTypes.BIGINT
      allowNull: true
    trip_calification:
      type: DataTypes.BIGINT
      allowNull: true
    trip_fail:
      type: DataTypes.BIGINT
      allowNull: true
    trip_sucess:
      type: DataTypes.BIGINT
      allowNull: true
    count_trips:
      type: DataTypes.BIGINT
      allowNull: true
    operator_id:
      type: DataTypes.BIGINT
      allowNull: false
    is_test_user:
      type: DataTypes.BOOLEAN

      allowNull: false
    count_reject_trip:
      type: DataTypes.BIGINT
      allowNull: true
    count_time_out:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'online_radio_taxi'
  }

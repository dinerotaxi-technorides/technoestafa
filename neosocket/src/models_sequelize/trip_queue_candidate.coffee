### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'trip_queue_candidate', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: false
    distance:
      type: 'DOUBLE'
      allowNull: false
    driver_id:
      type: DataTypes.BIGINT
      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: false
    lat:
      type: 'DOUBLE'
      allowNull: false
    lng:
      type: 'DOUBLE'
      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
    time_to_destination:
      type: DataTypes.INTEGER(11)
      allowNull: false
    operation_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'trip_queue_candidate'
  }

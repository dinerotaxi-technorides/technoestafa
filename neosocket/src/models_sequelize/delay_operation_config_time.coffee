### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'delay_operation_config_time', {
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
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    rtaxi_id:
      type: DataTypes.BIGINT
      allowNull: false
    time_delay_execution:
      type: DataTypes.INTEGER(11)
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'delay_operation_config_time'
  }

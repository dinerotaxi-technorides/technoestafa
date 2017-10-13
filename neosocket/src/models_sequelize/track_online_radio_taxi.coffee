### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'track_online_radio_taxi', {
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
    onlinertaxi_id:
      type: DataTypes.BIGINT
      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'track_online_radio_taxi'
  }

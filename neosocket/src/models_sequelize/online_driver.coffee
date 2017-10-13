### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'online_driver', {
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
      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    driver_id:
      type: DataTypes.BIGINT
      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    lat:
      type: DataTypes.FLOAT
      allowNull: true
    lng:
      type: DataTypes.FLOAT
      allowNull: true
    status:
      type: DataTypes.STRING
      allowNull: false
    driver_code:
      type: DataTypes.STRING
      allowNull: true
    driver_version:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'online_driver'
  }

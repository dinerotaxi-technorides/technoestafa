### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'online_taxi', {
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
    lat:
      type: DataTypes.FLOAT
      allowNull: true
    lng:
      type: DataTypes.FLOAT
      allowNull: true
    status:
      type: DataTypes.STRING
      allowNull: false
    taxista_id:
      type: DataTypes.BIGINT
      allowNull: false
    company_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'online_taxi'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'promotions', {
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
    dev:
      type: DataTypes.STRING
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    setting_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'promotions'
  }

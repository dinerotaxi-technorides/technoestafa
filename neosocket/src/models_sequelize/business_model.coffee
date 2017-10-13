### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'business_model', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    config_id:
      type: DataTypes.BIGINT
      allowNull: false
      references:
        model: 'business_config_model'
        key: 'id'
    name:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'business_model'
  }

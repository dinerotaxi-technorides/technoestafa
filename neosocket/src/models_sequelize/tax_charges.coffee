### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'tax_charges', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    charge:
      type: 'DOUBLE'
      allowNull: false
    config_id:
      type: DataTypes.BIGINT
      allowNull: false
      references:
        model: 'tax_config'
        key: 'id'
    name:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'tax_charges'
  }

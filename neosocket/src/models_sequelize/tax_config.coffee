### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'tax_config', {
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
    created_date:
      type: DataTypes.DATE
      allowNull: true
    is_compound:
      type: DataTypes.BOOLEAN

      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    rtaxi_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'tax_config'
  }

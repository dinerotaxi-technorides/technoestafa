### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'settings_promotions', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    code_qr:
      type: DataTypes.STRING
      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    discount:
      type: 'DOUBLE'
      allowNull: true
    finish_date:
      type: DataTypes.DATE
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: true
    start_date:
      type: DataTypes.DATE
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'settings_promotions'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'term_config', {
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
    days:
      type: DataTypes.INTEGER(11)
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
    tableName: 'term_config'
  }

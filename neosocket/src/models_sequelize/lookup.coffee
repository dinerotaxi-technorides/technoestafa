### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'lookup', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    code_maximum:
      type: DataTypes.STRING
      allowNull: true
    code_minimum:
      type: DataTypes.STRING
      allowNull: true
    code_scale:
      type: DataTypes.INTEGER(11)
      allowNull: true
    code_type:
      type: DataTypes.STRING
      allowNull: false
    date_created:
      type: DataTypes.DATE
      allowNull: false
    internationalize:
      type: DataTypes.BOOLEAN

      allowNull: false
    last_updated:
      type: DataTypes.DATE
      allowNull: false
    ordering:
      type: DataTypes.STRING
      allowNull: false
    realm:
      type: DataTypes.STRING
      allowNull: false
    value_maximum:
      type: DataTypes.STRING
      allowNull: true
    value_minimum:
      type: DataTypes.STRING
      allowNull: true
    value_scale:
      type: DataTypes.INTEGER(11)
      allowNull: true
    value_type:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'lookup'
  }

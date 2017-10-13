### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'zone', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    coordinates:
      type: DataTypes.TEXT
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'zone'
  }

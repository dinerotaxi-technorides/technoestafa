### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'contact', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    comment:
      type: DataTypes.TEXT
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    email:
      type: DataTypes.STRING
      allowNull: false
    first_name:
      type: DataTypes.STRING
      allowNull: true
    last_name:
      type: DataTypes.STRING
      allowNull: true
    phone:
      type: DataTypes.STRING
      allowNull: true
    subject:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'contact'
  }

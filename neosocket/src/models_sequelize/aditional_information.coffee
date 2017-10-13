### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'aditional_information', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    card_name:
      type: DataTypes.STRING
      allowNull: false
    code:
      type: DataTypes.STRING
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    credit_card:
      type: DataTypes.STRING
      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    month:
      type: DataTypes.STRING
      allowNull: false
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
    year:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'aditional_information'
  }

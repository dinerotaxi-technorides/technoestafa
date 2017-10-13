### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'credit_card_information', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: false
    enabled:
      type: DataTypes.BOOLEAN
      allowNull: false
    card_token:
      type: DataTypes.STRING
      allowNull: true
    card_type:
      type: DataTypes.STRING
      allowNull: true
    card_number:
      type: DataTypes.STRING
      allowNull: true
    card_holder:
      type: DataTypes.STRING
      allowNull: true
    cvc:
      type: DataTypes.STRING
      allowNull: true
    expiration_date:
      type: DataTypes.STRING
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'credit_card_information'
  }

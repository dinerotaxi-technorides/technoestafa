### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'expenses', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    base:
      type: 'DOUBLE'
      allowNull: true
    base1:
      type: 'DOUBLE'
      allowNull: true
    base10:
      type: 'DOUBLE'
      allowNull: true
    base11:
      type: 'DOUBLE'
      allowNull: true
    base2:
      type: 'DOUBLE'
      allowNull: true
    base3:
      type: 'DOUBLE'
      allowNull: true
    base8:
      type: 'DOUBLE'
      allowNull: true
    base9:
      type: 'DOUBLE'
      allowNull: true
    comments:
      type: DataTypes.STRING
      allowNull: true
    company:
      type: DataTypes.STRING
      allowNull: true
    concept:
      type: DataTypes.STRING
      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    credit_card_number:
      type: DataTypes.STRING
      allowNull: true
    currency:
      type: DataTypes.STRING
      allowNull: true
    enabled:
      type: DataTypes.BOOLEAN

      allowNull: false
    exchange:
      type: DataTypes.STRING
      allowNull: true
    fixed:
      type: DataTypes.BOOLEAN

      allowNull: false
    hadpaid:
      type: DataTypes.BOOLEAN

      allowNull: false
    is_authomatic:
      type: DataTypes.BOOLEAN

      allowNull: false
    receipt_number:
      type: DataTypes.STRING
      allowNull: true
    supplier:
      type: DataTypes.STRING
      allowNull: true
    tax:
      type: 'DOUBLE'
      allowNull: true
    tax1:
      type: 'DOUBLE'
      allowNull: true
    tax2:
      type: 'DOUBLE'
      allowNull: true
    tax3:
      type: 'DOUBLE'
      allowNull: true
    total:
      type: DataTypes.STRING
      allowNull: true
    type:
      type: DataTypes.STRING
      allowNull: true
    type_credit:
      type: DataTypes.STRING
      allowNull: true
    type_tax:
      type: DataTypes.STRING
      allowNull: true
    exchanges:
      type: DataTypes.STRING
      allowNull: true
    type_cuit:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'expenses'
  }

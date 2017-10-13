### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'suppliers', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    address1:
      type: DataTypes.STRING
      allowNull: false
    address2:
      type: DataTypes.STRING
      allowNull: false
    city:
      type: DataTypes.STRING
      allowNull: false
    company_name:
      type: DataTypes.STRING
      allowNull: false
    contact_name:
      type: DataTypes.STRING
      allowNull: false
    contact_title:
      type: DataTypes.STRING
      allowNull: false
    country:
      type: DataTypes.STRING
      allowNull: false
    current_order:
      type: DataTypes.STRING
      allowNull: false
    discount_avaible:
      type: DataTypes.BOOLEAN

      allowNull: false
    email:
      type: DataTypes.STRING
      allowNull: false
    fax:
      type: DataTypes.STRING
      allowNull: false
    first_contact:
      type: DataTypes.STRING
      allowNull: false
    logo:
      type: 'TINYBLOB'
      allowNull: false
    notes:
      type: DataTypes.STRING
      allowNull: false
    payment_methods:
      type: DataTypes.STRING
      allowNull: false
    phone:
      type: DataTypes.STRING
      allowNull: false
    postal_code:
      type: DataTypes.INTEGER(11)
      allowNull: false
    state:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'suppliers'
  }

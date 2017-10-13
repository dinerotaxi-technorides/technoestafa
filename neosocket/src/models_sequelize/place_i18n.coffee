### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'place_i18n', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    admin1code:
      type: DataTypes.STRING
      allowNull: true
    admin2code:
      type: DataTypes.STRING
      allowNull: true
    admin3code:
      type: DataTypes.STRING
      allowNull: true
    country:
      type: DataTypes.STRING
      allowNull: true
    country_code:
      type: DataTypes.STRING
      allowNull: true
    lang:
      type: DataTypes.STRING
      allowNull: false
    locality:
      type: DataTypes.STRING
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    place_id:
      type: DataTypes.BIGINT
      allowNull: false
    street:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'place_i18n'
  }

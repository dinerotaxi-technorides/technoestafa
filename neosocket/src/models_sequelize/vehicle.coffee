### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'vehicle', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    active:
      type: DataTypes.BOOLEAN

      allowNull: false
    company_id:
      type: DataTypes.BIGINT
      allowNull: true
    count_employer:
      type: DataTypes.INTEGER(11)
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    marca:
      type: DataTypes.STRING
      allowNull: false
    modelo:
      type: DataTypes.STRING
      allowNull: false
    owner_id:
      type: DataTypes.BIGINT
      allowNull: true
    patente:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'vehicle'
  }

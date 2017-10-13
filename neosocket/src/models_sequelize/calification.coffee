### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'calification', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    comments:
      type: DataTypes.STRING
      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    operation_id:
      type: DataTypes.BIGINT
      allowNull: false
    stars:
      type: DataTypes.INTEGER(11)
      allowNull: false
    taxista_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'calification'
  }

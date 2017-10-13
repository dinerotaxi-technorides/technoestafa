### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'lookup_value', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    code:
      type: DataTypes.STRING
      allowNull: false
    date_created:
      type: DataTypes.DATE
      allowNull: false
    last_updated:
      type: DataTypes.DATE
      allowNull: false
    lookup_id:
      type: DataTypes.BIGINT
      allowNull: false
    numeric_sequencer:
      type: DataTypes.DECIMAL
      allowNull: false
    sequencer:
      type: DataTypes.INTEGER(11)
      allowNull: false
    string_sequencer:
      type: DataTypes.STRING
      allowNull: false
    value:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'lookup_value'
  }

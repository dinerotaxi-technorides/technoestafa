### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'destination', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    area:
      type: DataTypes.STRING
      allowNull: true
    best_time_to_visit:
      type: DataTypes.STRING
      allowNull: true
    calling_code:
      type: DataTypes.STRING
      allowNull: true
    capital:
      type: DataTypes.STRING
      allowNull: true
    climate:
      type: DataTypes.STRING
      allowNull: true
    costs:
      type: DataTypes.STRING
      allowNull: true
    currency:
      type: DataTypes.STRING
      allowNull: true
    electricity:
      type: DataTypes.STRING
      allowNull: true
    getting_around:
      type: DataTypes.STRING
      allowNull: true
    getting_there:
      type: DataTypes.STRING
      allowNull: true
    health_and_safety:
      type: DataTypes.STRING
      allowNull: true
    introduction:
      type: DataTypes.TEXT
      allowNull: true
    known_for:
      type: DataTypes.STRING
      allowNull: true
    language:
      type: DataTypes.STRING
      allowNull: true
    location_id:
      type: DataTypes.BIGINT
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    population:
      type: DataTypes.STRING
      allowNull: true
    religion:
      type: DataTypes.STRING
      allowNull: true
    timezone:
      type: DataTypes.STRING
      allowNull: true
    visas:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'destination'
  }

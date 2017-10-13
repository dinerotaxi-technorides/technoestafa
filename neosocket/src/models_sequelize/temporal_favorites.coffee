### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'temporal_favorites', {
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
    enabled:
      type: DataTypes.BOOLEAN

      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    name:
      type: DataTypes.STRING
      allowNull: false
    place_from_id:
      type: DataTypes.BIGINT
      allowNull: false
    place_from_dto:
      type: DataTypes.STRING
      allowNull: true
    place_from_pso:
      type: DataTypes.STRING
      allowNull: true
    place_to_id:
      type: DataTypes.BIGINT
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
    class:
      type: DataTypes.STRING
      allowNull: false
    place_to_apartment:
      type: DataTypes.STRING
      allowNull: true
    place_to_floor:
      type: DataTypes.STRING
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'temporal_favorites'
  }

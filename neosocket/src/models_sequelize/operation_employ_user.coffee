### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'operation_employ_user', {
    operation_candidates_id:
      type: DataTypes.BIGINT
      allowNull: true
    employ_user_id:
      type: DataTypes.BIGINT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'operation_employ_user'
  }

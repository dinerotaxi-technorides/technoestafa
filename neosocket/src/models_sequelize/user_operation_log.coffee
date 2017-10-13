### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user_operation_log', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    code:
      type: DataTypes.INTEGER(11)
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: false
    operation_id:
      type: DataTypes.BIGINT
      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
    reason:
      type: DataTypes.STRING
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'user_operation_log'
  }

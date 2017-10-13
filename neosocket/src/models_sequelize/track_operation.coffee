### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'track_operation', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    created_date:
      type: DataTypes.DATE
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    onlinertaxi_id:
      type: DataTypes.BIGINT
      allowNull: true
    operation_id:
      type: DataTypes.BIGINT
      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
    taxista_id:
      type: DataTypes.BIGINT
      allowNull: true
    time_travel:
      type: DataTypes.BIGINT
      allowNull: true
    comment:
      type: DataTypes.STRING
      allowNull: true
    is_company_account:
      type: DataTypes.BOOLEAN

      allowNull: false
  }, {
    timestamps: false,
    tableName: 'track_operation'
  }

### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'delay_operation', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    company_id:
      type: DataTypes.BIGINT
      allowNull: true
    company_user_id:
      type: DataTypes.BIGINT
      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    dev:
      type: DataTypes.STRING
      allowNull: false
    executed_time:
      type: DataTypes.DATE
      allowNull: true
    execution_time:
      type: DataTypes.DATE
      allowNull: false
    favorites_id:
      type: DataTypes.BIGINT
      allowNull: false
    intermediario_id:
      type: DataTypes.BIGINT
      allowNull: true
    is_company_account:
      type: DataTypes.BOOLEAN

      allowNull: false
    is_test_user:
      type: DataTypes.BOOLEAN

      allowNull: false
    options_id:
      type: DataTypes.BIGINT
      allowNull: true
      references:
        model: 'options'
        key: 'id'
    send_to_operation:
      type: DataTypes.BOOLEAN

      allowNull: false
    status:
      type: DataTypes.STRING
      allowNull: false
    taxista_id:
      type: DataTypes.BIGINT
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: true
    driver_number:
      type: DataTypes.INTEGER(11)
      allowNull: true
    payment_reference:
      type: DataTypes.STRING
      allowNull: true
    created_by_operator:
      type: DataTypes.BOOLEAN

      allowNull: false
    ip:
      type: DataTypes.STRING
      allowNull: false
    operation_id:
      type: DataTypes.BIGINT
      allowNull: true
    amount:
      type: DataTypes.DECIMAL
      allowNull: true
    time_delay_execution:
      type: DataTypes.INTEGER(11)
      allowNull: true
    business_model:
      type: DataTypes.STRING
      allowNull: false
    pushed_to_device:
      type: DataTypes.BOOLEAN

      allowNull: false
  }, {
    timestamps: false,
    tableName: 'delay_operation'
  }

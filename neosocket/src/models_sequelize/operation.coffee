### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'operation', {
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
    created_date:
      type: DataTypes.DATE
      allowNull: true
    dev:
      type: DataTypes.STRING
      allowNull: false
    enabled:
      type: DataTypes.BOOLEAN

      allowNull: false
    favorites_id:
      type: DataTypes.BIGINT
      allowNull: false
    intermediario_id:
      type: DataTypes.BIGINT
      allowNull: true
    is_test_user:
      type: DataTypes.BOOLEAN

      allowNull: false
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    parent_id:
      type: DataTypes.BIGINT
      allowNull: true
    status:
      type: DataTypes.STRING
      allowNull: false
    taxista_id:
      type: DataTypes.BIGINT
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: true
    class:
      type: DataTypes.STRING
      allowNull: false
    time_travel:
      type: DataTypes.BIGINT
      allowNull: true
    amount:
      type: DataTypes.DECIMAL
      allowNull: true
    company_user_id:
      type: DataTypes.BIGINT
      allowNull: true
    is_company_account:
      type: DataTypes.BOOLEAN

      allowNull: false
    options_id:
      type: DataTypes.BIGINT
      allowNull: true
    send_to_socket:
      type: DataTypes.BOOLEAN

      allowNull: false
    stars:
      type: DataTypes.INTEGER(11)
      allowNull: true
    driver_number:
      type: DataTypes.INTEGER(11)
      allowNull: true
    payment_reference:
      type: DataTypes.STRING
      allowNull: true
    corporate_id:
      type: DataTypes.BIGINT
      allowNull: true
    cost_center_id:
      type: DataTypes.BIGINT
      allowNull: true
    created_by_operator:
      type: DataTypes.BOOLEAN

      allowNull: false
    ip:
      type: DataTypes.STRING
      allowNull: false
    is_delay_operation:
      type: DataTypes.BOOLEAN

      allowNull: false
    queue_type:
      type: DataTypes.STRING
      allowNull: false
    user_type:
      type: DataTypes.STRING
      allowNull: false
    business_model:
      type: DataTypes.STRING
      allowNull: false
    queue_date:
      type: DataTypes.DATE
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'operation'
  }

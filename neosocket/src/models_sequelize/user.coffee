### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'user', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    is_corporate:
      type: DataTypes.BOOLEAN
      allowNull: false
    is_vip:
      type: DataTypes.BOOLEAN

      allowNull: false
    is_pet:
      type: DataTypes.BOOLEAN

      allowNull: false
    is_air_conditioning:
      type: DataTypes.BOOLEAN

      allowNull: false
    is_smoker:
      type: DataTypes.BOOLEAN

      allowNull: false
    is_special_assistant:
      type: DataTypes.BOOLEAN

      allowNull: false
    is_luggage:
      type: DataTypes.BOOLEAN

      allowNull: false
    is_airport:
      type: DataTypes.BOOLEAN
      allowNull: false
    is_messaging:
      type: DataTypes.BOOLEAN
      allowNull: false
    is_invoice:
      type: DataTypes.BOOLEAN
      allowNull: false
    is_regular:
      type: DataTypes.BOOLEAN
      allowNull: false
    account_expired:
      type: DataTypes.BOOLEAN

      allowNull: false
    account_locked:
      type: DataTypes.BOOLEAN

      allowNull: false
    email:
      type: DataTypes.STRING
      allowNull: false
    enabled:
      type: DataTypes.BOOLEAN

      allowNull: false
    first_name:
      type: DataTypes.STRING
      allowNull: true
    is_test_user:
      type: DataTypes.BOOLEAN

      allowNull: false
    last_name:
      type: DataTypes.STRING
      allowNull: true
    password:
      type: DataTypes.STRING
      allowNull: false
    password_expired:
      type: DataTypes.BOOLEAN

      allowNull: false
    phone:
      type: DataTypes.STRING
      allowNull: true
    phone1:
      type: DataTypes.STRING
      allowNull: true
    username:
      type: DataTypes.STRING
      allowNull: false
    class:
      type: DataTypes.STRING
      allowNull: false
    agree:
      type: DataTypes.BOOLEAN

      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    politics:
      type: DataTypes.BOOLEAN

      allowNull: true
    status:
      type: DataTypes.STRING
      allowNull: true
    employee_id:
      type: DataTypes.BIGINT
      allowNull: true
    type_employ:
      type: DataTypes.STRING
      allowNull: true
    company_name:
      type: DataTypes.STRING
      allowNull: true
    cuit:
      type: DataTypes.STRING
      allowNull: true
    app_version:
      type: DataTypes.INTEGER(11)
      allowNull: true
    mail_contacto:
      type: DataTypes.STRING
      allowNull: true
    validated:
      type: DataTypes.STRING
      allowNull: true
    usr_device:
      type: DataTypes.STRING
      allowNull: true
    ip:
      type: DataTypes.STRING
      allowNull: true
    rtaxi_id:
      type: DataTypes.BIGINT
      allowNull: true
    count_trips_completed:
      type: DataTypes.INTEGER(11)
      allowNull: false
    is_frequent:
      type: DataTypes.BOOLEAN

      allowNull: false
    city_id:
      type: DataTypes.BIGINT
      allowNull: true
    lang:
      type: DataTypes.STRING
      allowNull: true
    wlconfig_id:
      type: DataTypes.BIGINT
      allowNull: true
    facebookid:
      type: DataTypes.INTEGER(11)
      allowNull: true
    facebooktoken:
      type: DataTypes.STRING
      allowNull: true
    latitude:
      type: DataTypes.FLOAT
      allowNull: true
    longitude:
      type: DataTypes.FLOAT
      allowNull: true
    count_login:
      type: DataTypes.INTEGER(11)
      allowNull: true
    price:
      type: DataTypes.STRING
      allowNull: true
    licence_end_date:
      type: DataTypes.DATE
      allowNull: true
    licence_number:
      type: DataTypes.STRING
      allowNull: true
    visible:
      type: DataTypes.BOOLEAN

      allowNull: true
    page_url:
      type: DataTypes.STRING
      allowNull: true
    admin:
      type: DataTypes.BOOLEAN

      allowNull: true
    cost_center_id:
      type: DataTypes.BIGINT
      allowNull: true
    corporate_super_user:
      type: DataTypes.BOOLEAN

      allowNull: false
    limit_drivers:
      type: DataTypes.STRING
      allowNull: true
    status_plan:
      type: DataTypes.STRING
      allowNull: true
    is_profile_editable:
      type: DataTypes.BOOLEAN

      allowNull: false
  },{
    timestamps: false,
    tableName: 'user'
  }

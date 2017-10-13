### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'configuration_app', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: true
    android_account_type:
      type: DataTypes.STRING
      allowNull: true
    android_email:
      type: DataTypes.STRING
      allowNull: true
    android_pass:
      type: DataTypes.STRING
      allowNull: true
    android_token:
      type: DataTypes.STRING
      allowNull: true
    app:
      type: DataTypes.STRING
      allowNull: true
    apple_certificate_path:
      type: DataTypes.STRING
      allowNull: true
    apple_ip:
      type: DataTypes.STRING
      allowNull: true
    apple_password:
      type: DataTypes.STRING
      allowNull: true
    apple_port:
      type: DataTypes.INTEGER(11)
      allowNull: true
    is_enable:
      type: DataTypes.BOOLEAN
      allowNull: true
    mail_from:
      type: DataTypes.STRING
      allowNull: true
    mail_secret:
      type: DataTypes.STRING
      allowNull: true
    mailkey:
      type: DataTypes.STRING
      allowNull: true
    send_notification:
      type: DataTypes.BOOLEAN
      allowNull: true
    android_url:
      type: DataTypes.STRING
      allowNull: true
    bb10url:
      type: DataTypes.STRING
      allowNull: true
    ios_url:
      type: DataTypes.STRING
      allowNull: true
    windows_phone_url:
      type: DataTypes.STRING
      allowNull: true
    interval_pooling_trip:
      type: DataTypes.INTEGER(11)
      allowNull: true
    interval_pooling_trip_in_transaction:
      type: DataTypes.INTEGER(11)
      allowNull: true
    distance_search_trip:
      type: DataTypes.FLOAT
      allowNull: true
      defaultValue: '1'
    driver_search_trip:
      type: DataTypes.INTEGER(11)
      allowNull: true
      defaultValue: '3'
    time_delay_trip:
      type: DataTypes.INTEGER(11)
      allowNull: true
      defaultValue: '10'
    parking:
      type: DataTypes.BOOLEAN
      allowNull: true
    driver_amount_payment:
      type: 'DOUBLE'
      allowNull: true
    driver_payment:
      type: DataTypes.INTEGER(11)
      allowNull: true
    driver_type_payment:
      type: DataTypes.INTEGER(11)
      allowNull: true
    has_driver_payment:
      type: DataTypes.BOOLEAN
      allowNull: true
    parking_distance_driver:
      type: DataTypes.INTEGER(11)
      allowNull: true
    parking_distance_trip:
      type: DataTypes.INTEGER(11)
      allowNull: true
    cost_rute:
      type: DataTypes.INTEGER(11)
      allowNull: true
    cost_rute_per_km:
      type: 'DOUBLE'
      allowNull: true
    cost_rute_per_km_min:
      type: 'DOUBLE'
      allowNull: true
    digital_radio:
      type: DataTypes.BOOLEAN
      allowNull: true
    percentage_search_ratio:
      type: DataTypes.FLOAT
      allowNull: true
    has_required_zone:
      type: DataTypes.BOOLEAN
      allowNull: true
    has_zone_active:
      type: DataTypes.BOOLEAN
      allowNull: true
    page_company_description:
      type: DataTypes.TEXT
      allowNull: true
    page_company_facebook:
      type: DataTypes.STRING
      allowNull: true
    page_company_linkedin:
      type: DataTypes.STRING
      allowNull: true
    page_company_state:
      type: DataTypes.STRING
      allowNull: true
    page_company_street:
      type: DataTypes.STRING
      allowNull: true
    page_company_title:
      type: DataTypes.STRING
      allowNull: true
    page_company_twitter:
      type: DataTypes.STRING
      allowNull: true
    page_company_zip_code:
      type: DataTypes.STRING
      allowNull: true
    page_title:
      type: DataTypes.STRING
      allowNull: true
    has_mobile_payment:
      type: DataTypes.BOOLEAN
      allowNull: true
    paypal:
      type: DataTypes.BOOLEAN
      allowNull: true
    merchant_id:
      type: DataTypes.STRING
      allowNull: true
    mobile_currency:
      type: DataTypes.STRING
      allowNull: true
    has_required_km:
      type: DataTypes.BOOLEAN
      allowNull: false
    endless_dispatch:
      type: DataTypes.BOOLEAN
      allowNull: false
    zoho:
      type: DataTypes.STRING
      allowNull: true
    use_admin_code:
      type: DataTypes.BOOLEAN
      allowNull: false
    had_user_number:
      type: DataTypes.BOOLEAN
      allowNull: false
    page_company_logo:
      type: DataTypes.STRING
      allowNull: true
    page_company_web:
      type: DataTypes.STRING
      allowNull: true
    currency:
      type: DataTypes.STRING
      allowNull: true
    map_key:
      type: DataTypes.STRING
      allowNull: false
    new_opshow_address_from:
      type: DataTypes.BOOLEAN
      allowNull: false
    new_opshow_address_to:
      type: DataTypes.BOOLEAN
      allowNull: false
    new_opshow_corporate:
      type: DataTypes.BOOLEAN
      allowNull: false
    new_opshow_user_name:
      type: DataTypes.BOOLEAN
      allowNull: false
    new_opshow_user_phone:
      type: DataTypes.BOOLEAN
      allowNull: false
    new_op_comment:
      type: DataTypes.BOOLEAN
      allowNull: false
    fare_config_activate_time_per_distance:
      type: DataTypes.INTEGER(11)
      allowNull: false
    fare_config_time_initial_sec_wait:
      type: DataTypes.INTEGER(11)
      allowNull: false
    fare_config_time_sec_wait:
      type: DataTypes.INTEGER(11)
      allowNull: false
    fare_cost_per_km:
      type: 'DOUBLE'
      allowNull: false
    fare_cost_time_wait_perxseg:
      type: 'DOUBLE'
      allowNull: false
    fare_initial_cost:
      type: 'DOUBLE'
      allowNull: false
    has_driver_dispatcher_function:
      type: DataTypes.BOOLEAN
      allowNull: false
    is_fare_calculator_active:
      type: DataTypes.BOOLEAN
    credit_card_enable:
      type: DataTypes.BOOLEAN
      allowNull: false
    new_opshow_options:
      type: DataTypes.BOOLEAN
      allowNull: false
    parking_polygon:
      type: DataTypes.BOOLEAN
      allowNull: false
    dispute_time_trip:
      type: DataTypes.INTEGER(11)
      allowNull: false
    driver_cancel_trip:
      type: DataTypes.BOOLEAN
      allowNull: false
    is_queue_trip_activated:
      type: DataTypes.BOOLEAN
      allowNull: false
    operator_dispatch_multiple_trips:
      type: DataTypes.BOOLEAN
      allowNull: false
    operator_suggest_destination:
      type: DataTypes.BOOLEAN
      allowNull: false
    passenger_dispatch_multiple_trips:
      type: DataTypes.BOOLEAN
      allowNull: false
    queue_trip_type:
      type: DataTypes.STRING
      allowNull: false
    block_multiple_trips:
      type: DataTypes.BOOLEAN
      allowNull: false
    driver_corporate_charge:
      type: 'DOUBLE'
      allowNull: false
      defaultValue: '100'
    drivers_profile_editable:
      type: DataTypes.BOOLEAN
      allowNull: false
    is_chat_enabled:
      type: DataTypes.BOOLEAN
      allowNull: false
    fare_cost_time_initial_sec_wait:
      type: 'DOUBLE'
      allowNull: false
    operator_cancelation_reason:
      type: DataTypes.BOOLEAN
      allowNull: false
    is_pre_paid_active:
      type: DataTypes.BOOLEAN
      allowNull: false
    driver_show_schedule_trips:
      type: DataTypes.BOOLEAN
      allowNull: false
      defaultValue: false
    google_api_key:
      type: DataTypes.STRING
      allowNull: false
    distance_type:
      type: DataTypes.STRING
      allowNull: false
    fare_config_grace_period_meters:
      type: DataTypes.INTEGER(11)
      allowNull: false
    fare_config_grace_time:
      type: DataTypes.INTEGER(11)
      allowNull: false
    driver_quota:
      type: DataTypes.INTEGER(11)
      allowNull: true
    package_company:
      type: DataTypes.STRING
      allowNull: false
    driver_cancellation_reason:
      type: DataTypes.BOOLEAN,
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'configuration_app'
  }

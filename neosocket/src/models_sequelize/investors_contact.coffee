### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'investors_contact', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    company_name:
      type: DataTypes.STRING
      allowNull: true
    company_position:
      type: DataTypes.STRING
      allowNull: true
    country:
      type: DataTypes.STRING
      allowNull: true
    created_date:
      type: DataTypes.DATE
      allowNull: true
    email:
      type: DataTypes.STRING
      allowNull: false
    facebook_url:
      type: DataTypes.STRING
      allowNull: true
    first_name:
      type: DataTypes.STRING
      allowNull: true
    last_modified_date:
      type: DataTypes.DATE
      allowNull: true
    last_name:
      type: DataTypes.STRING
      allowNull: true
    linkedin_url:
      type: DataTypes.STRING
      allowNull: true
    phone:
      type: DataTypes.STRING
      allowNull: true
    plataform_url:
      type: DataTypes.STRING
      allowNull: true
    profile_type:
      type: DataTypes.STRING
      allowNull: false
    range_invest:
      type: DataTypes.STRING
      allowNull: true
    startup_investor:
      type: DataTypes.STRING
      allowNull: true
    status:
      type: DataTypes.STRING
      allowNull: true
    website:
      type: DataTypes.STRING
      allowNull: true
    city:
      type: DataTypes.TEXT
      allowNull: true
    country_code:
      type: DataTypes.TEXT
      allowNull: true
    description:
      type: DataTypes.TEXT
      allowNull: true
    funding_types:
      type: DataTypes.TEXT
      allowNull: true
    investor_city:
      type: DataTypes.TEXT
      allowNull: true
    investor_code_country:
      type: DataTypes.TEXT
      allowNull: true
    investor_postal_code:
      type: DataTypes.TEXT
      allowNull: true
    investor_state_code:
      type: DataTypes.TEXT
      allowNull: true
    investor_type:
      type: DataTypes.TEXT
      allowNull: true
    json:
      type: DataTypes.TEXT
      allowNull: true
    link:
      type: DataTypes.TEXT
      allowNull: true
    max_investment:
      type: DataTypes.TEXT
      allowNull: true
    min_investment:
      type: DataTypes.TEXT
      allowNull: true
    postal_code:
      type: DataTypes.TEXT
      allowNull: true
    profile_key_startupco:
      type: DataTypes.TEXT
      allowNull: true
    state_code:
      type: DataTypes.TEXT
      allowNull: true
    title:
      type: DataTypes.TEXT
      allowNull: true
    type_investment:
      type: DataTypes.TEXT
      allowNull: true
    user_id:
      type: DataTypes.TEXT
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'investors_contact'
  }

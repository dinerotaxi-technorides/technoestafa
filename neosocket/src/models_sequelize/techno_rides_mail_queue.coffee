### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'techno_rides_mail_queue', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    body:
      type: DataTypes.TEXT
      allowNull: false
    date_created:
      type: DataTypes.DATE
      allowNull: false
    email_builder_id:
      type: DataTypes.BIGINT
      allowNull: false
      references:
        model: 'email_builder'
        key: 'id'
    from_id:
      type: DataTypes.BIGINT
      allowNull: false
    last_updated:
      type: DataTypes.DATE
      allowNull: false
    subject:
      type: DataTypes.STRING
      allowNull: false
    to_id:
      type: DataTypes.BIGINT
      allowNull: false
  }, {
    timestamps: false,
    tableName: 'techno_rides_mail_queue'
  }

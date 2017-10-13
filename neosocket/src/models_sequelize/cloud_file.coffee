### jshint indent: 2 ###

module.exports = (sequelize, DataTypes) ->
  sequelize.define 'cloud_file', {
    id:
      type: DataTypes.BIGINT
      allowNull: false
      primaryKey: true
      autoIncrement: true
    version:
      type: DataTypes.BIGINT
      allowNull: false
    caption:
      type: DataTypes.STRING
      allowNull: true
    container:
      type: DataTypes.STRING
      allowNull: true
    date_created:
      type: DataTypes.DATE
      allowNull: false
    filename:
      type: DataTypes.STRING
      allowNull: true
    filesize:
      type: DataTypes.INTEGER(11)
      allowNull: false
    last_updated:
      type: DataTypes.DATE
      allowNull: false
    mime_type:
      type: DataTypes.STRING
      allowNull: true
    url:
      type: DataTypes.STRING
      allowNull: true
    user_id:
      type: DataTypes.BIGINT
      allowNull: false
    uuid:
      type: DataTypes.STRING
      allowNull: false
    class:
      type: DataTypes.STRING
      allowNull: false
    height:
      type: DataTypes.INTEGER(11)
      allowNull: true
    image_size:
      type: DataTypes.STRING
      allowNull: true
    picture_id:
      type: DataTypes.BIGINT
      allowNull: true
    width:
      type: DataTypes.INTEGER(11)
      allowNull: true
  }, {
    timestamps: false,
    tableName: 'cloud_file'
  }

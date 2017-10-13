'use strict'
fs        = require('fs')
path      = require('path')
Sequelize = require('sequelize')
config    = require '../../config'
cfg_db    = require(path.join(__dirname, '../..', 'config', 'config.json'))[config.env]
sequelize = new Sequelize(cfg_db.database, cfg_db.username, cfg_db.password, cfg_db.options)
db        = {}


onlyModelFiles = (file) ->
  file.indexOf('.') != 0 and file != 'index.js' and file.indexOf('.map') == -1  and file.indexOf('.sh') == -1

fs.readdirSync(__dirname).filter(onlyModelFiles).forEach (file) ->
  model          = sequelize.import(path.join(__dirname, file))
  db[model.name] = model
  return

Object.keys(db).forEach (modelName) ->
  if 'associate' of db[modelName]
    db[modelName].associate db
  return

db.sequelize   = sequelize
db.Sequelize   = Sequelize
module.exports = db

sequelize.authenticate().then ((err) ->
  console.log 'MYSQL Connection has been established successfully.'
  return
), (err) ->
  console.log 'MYSQL Unable to connect to the database:', err
  return

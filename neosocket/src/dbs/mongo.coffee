M             = require 'mongoose'
config        = require '../../config'

# view http://mongoosejs.com/docs/2.7.x/docs/defaults.html
connection = null

# db.companies.createIndex( { company_id: 1 }, { unique: true } )
# db.drivers.createIndex( { driver_id: 1 }, { unique: true } )
# db.users.createIndex( { user_id: 1 }, { unique: true } )
# db.operations.createIndex( { operation_id: 1 }, { unique: true } )

# db.companies.dropIndex( { company_id: 1 } )
# db.drivers.dropIndex( { driver_id: 1 })
# db.users.dropIndex( { user_id: 1 } )
# db.operations.dropIndex( { operation_id: 1 })

@connect = connect = (next = ->) ->
  {host, db, port} = config.mongo

  connection = M.connect "mongodb://#{host}/#{db}", { db: { safe: true }}, next

#FIXME call function connect on import take care with this
@connect (err) =>
    if err?
      console.log "Mongo: ERROR Connection error: #{err}"
    else
      console.log "Mongo: Connected"


@disconnect = disconnect = ->
  connection.disconnect()


update_timestamp = (next) ->
  @created_at = Date.now() unless @created_at?
  @updated_at = Date.now()
  next()

@getRandomObjectId = getRandomObjectId = =>
  M.Types.ObjectId()

@Widget = M.model "Widget", (M.Schema

  name: String

  created_at: Date
  updated_at: Date
    #validate: (x) -> x.length > 4 and '@' in x

).pre 'save', update_timestamp



GooglePlace = M.Schema
    place_id  : String
    last_scan : { type: Date, default: null }
    last_crawl: { type: Date, default: null }
    name      : String
    types     : [String]
    vicinity  : String
    address   : String
    location  : { type: { lat: Number, lng: Number }}
    website   : String
    emails    : [String]
    details   : {} # raw detail object from Places API, just in case

GooglePlace.index({ 'location': '2dsphere' })

@GooglePlace = M.model "GooglePlace", (GooglePlace)

Geoname = M.Schema
    geonameid  : String
    name       : String
    asciiname  : String
    population : String
    location   : { type: { lat: Number, lng: Number }}
    timezone   : String

Geoname.index({ 'location': '2dsphere' })

@Geoname = M.model "Geoname", (Geoname)

CompanySchema = M.Schema

  company_id: Number

  rtaxi_id: Number

  token: String

  is_connected:
    type : Boolean
    default: false
  device_type:
    type : String
    default: 'ANDROID'
  device_key:
    type : String
    default: ''

  created_at: Date
  updated_at: Date

CompanySchema.index({company_id: 1}, {unique: true})

@Company = M.model "Company", (CompanySchema
).pre 'save', update_timestamp



@Guest = M.model "Guest", (M.Schema


  created_at: Date
  updated_at: Date

).pre 'save', update_timestamp

@Message = M.model "Message", (M.Schema

  receiver_id: Number

  message: String

  was_read:
    type   : Boolean
    default: false

  created_at: Date
  updated_at: Date

).pre 'save', update_timestamp

Parking = M.Schema
  rtaxi_id: Number

  parking_id: Number

  name: String

  location:
    type :  [Number]
    index: '2dsphere'

  coordinates_in:
    type: { type: String }
    coordinates: Array

  coordinates_out:
    type: { type: String }
    coordinates: Array

  is_polygon:
    type   : Boolean
    default: false

  business_model:
    type   : String
    default: 'GENERIC'

  created_at: Date
  updated_at: Date

Parking.index({ 'location': '2dsphere' })
Parking.index({ 'coordinates_in': '2dsphere' })
Parking.index({ 'coordinates_out': '2dsphere' })

@Parking = M.model "Parking", (Parking
).pre 'save', update_timestamp

DriverParkingQueue = M.Schema

  driver:
    type: M.Schema.ObjectId
    ref: 'Driver'

  parking:
    type: M.Schema.ObjectId
    ref : 'Parking'
    default: null

  position:
    type : Number
    default: -1

  created_at: Date
  updated_at: Date

DriverParkingQueue.index({driver: 1, parking: 1}, {unique: true})

@DriverParkingQueue  = M.model "DriverParkingQueue", (DriverParkingQueue
).pre 'save', update_timestamp


ParkingQueuesSchema = M.Schema
  driver_id: Number

  parking_id: Number

  position:
    type : Number
    default: -1

  created_at: Date
  updated_at: Date

ParkingQueuesSchema.index({driver_id: 1,parking_id: 1}, {unique: true})

@ParkingQueues = M.model "ParkingQueues", (ParkingQueuesSchema
).pre 'save', update_timestamp

Zone = M.Schema

  rtaxi_id: Number

  zone_id: Number

  location:[]
    # index: '2dsphere'
  geopoly:
    type: { type: String }
    coordinates: Array

  name: String

  created_at: Date
  updated_at: Date

Zone.index({ 'geopoly': '2dsphere' })

@Zone = M.model "Zone", (Zone

).pre 'save', update_timestamp


ZonePoint = M.Schema
  token     : String
  location  :
    type: { type: String }
    coordinates: Array
  created_at: Date
  updated_at: Date
  rtaxi_id  : Number

ZonePoint.index({ 'location': '2dsphere' })

@ZonePoint = M.model "ZonePoint", (ZonePoint
).pre 'save', update_timestamp


@CompanyConfig = M.model "CompanyConfig", (M.Schema

  rtaxi_id:
    type   : Number
    default: 0

  time_delay_trip:
    type   : Number
    default: 0

  distance_search_trip:
    type   : Number
    default: 0

  driver_search_trip:
    type   : Number
    default: 0

  parking_distance_driver:
    type   : Number
    default: 0

  parking_distance_trip:
    type   : Number
    default: 0

  percentage_search_ratio:
    type   : Number
    default: 0

  phone_number:
    type: String
    default: ''
  had_user_number:
    type : Boolean
    default: false

  parking:
    type   : Boolean
    default: false

  has_zone_active:
    type   : Boolean
    default: false

  has_mobile_payment:
    type   : Boolean
    default: false

  paypal:
    type   : Boolean
    default: false

  has_required_zone:
    type   : Boolean
    default: false

  endless_dispatch:
    type   : Boolean
    default: false

  parking_polygon:
    type   : Boolean
    default: false

  cost_rute:Number

  cost_rute_per_km:Number

  cost_rute_per_km_min:Number

  has_driver_dispatcher_function:
    type   : Boolean
    default: false

  is_fare_calculator_active:
    type   : Boolean
    default: false
  credit_card_enable:
    type   : Boolean
    default: false

  fare_initial_cost:
    type   : Number
    default: 0

  fare_cost_per_km:
    type   : Number
    default: 0
  fare_config_activate_time_per_distance:
    type   : Number
    default: 0

  fare_config_time_initial_sec_wait:
    type   : Number
    default: 0
  fare_config_time_sec_wait:
    type   : Number
    default: 0
  fare_cost_time_wait_perxseg:
    type   : Number
    default: 0
  fare_cost_time_initial_sec_wait :
    type   : Number
    default: 0

  fare_config_grace_period_meters:
    type   : Number
    default: 0

  fare_config_grace_time:
    type   : Number
    default: 0

  zoho:String

  driver_cancel_trip:
    type   : Boolean
    default: false

  is_queue_trip_activated:
    type   : Boolean
    default: false

  dispute_time_trip:
    type   : Number
    default: 20

  queue_trip_type:
    type: String
    default: 'FIRST_TAKE'

  apple_password:
    type: String
    default: ''

  apple_ip:
    type: String
    default: ''

  apple_port:
    type: String
    default: ''

  apple_certificate_path:
    type: String
    default: ''

  android_token:
    type: String
    default: ''

  created_at: Date
  updated_at: Date

).pre 'save', update_timestamp

DriverSchema = M.Schema

  driver_id:
    type   : Number
    default: 0
  rtaxi_id:
    type   : Number
    default: 0
  business_model:
    type:[String]
    default:['GENERIC']

  car_status:
    type   : String
    default: ''

  status    :
    type : String
    default: 'DISCONNECTED'
  token     :
    type   : String
    default: ''

  first_name:
    type   : String
    default: ''
  last_name :
    type   : String
    default: ''
  email     : String
  phone     :
    type   : String
    default: ''

  brand:
    type : String
    default: ''
  model:
    type : String
    default: ''
  plate:
    type : String
    default: ''

  version:
    type : String
    default: ''
  serial :
    type : String
    default: ''
  is_fake     :
    type   : Boolean
    default: false
  is_connected:
    type   : Boolean
    default: false
  is_blocked:
    type   : Boolean
    default: false

  is_regular:
    type   : Boolean
    default: true
  is_corporate:
    type   : Boolean
    default: true
  is_vip:
    type   : Boolean
    default: true
  is_pet:
    type   : Boolean
    default: true
  is_air_conditioning:
    type   : Boolean
    default: true
  is_smoker:
    type   : Boolean
    default: true
  is_special_assistant:
    type   : Boolean
    default: true
  is_luggage:
    type   : Boolean
    default: true
  is_airport:
    type   : Boolean
    default: true
  is_invoice:
    type   : Boolean
    default: true
  is_messaging:
    type   : Boolean
    default: true

  location:
    type : [Number]
    index: '2dsphere'
    default: [0,0]

  device_type:
    type : String
    default: 'ANDROID'
  device_key:
    type : String
    default: ''
  created_at: Date
  updated_at: Date
  , { versionKey: false }

DriverSchema.index({driver_id: 1}, {unique: true})

@Driver = M.model "Driver", (DriverSchema

).pre 'save', update_timestamp

UserSchema = M.Schema
  user_id    :
    type   : Number
    default: 0
  rtaxi_id   :
    type   : Number
    default: 0
  employee_id:
    type   : Number
    default: 0
  city_id    :
    type   : Number
    default: 0

  token: String

  email     : String
  first_name: String
  last_name : String
  language  : String

  phone       : String
  company_name: String

  corporate_name:
    type   : String
    default: ""

  cost_center_name:
    type   : String
    default: ""

  is_frequent :
    type   : Boolean
    default: false
  is_cc       :
    type   : Boolean
    default: false
  is_connected:
    type   : Boolean
    default: true

  device_type:
    type : String
    default: 'ANDROID'

  device_key:
    type : String
    default: ''

  location:
    type : [Number]
    index: '2dsphere'
    default: [0,0]

  created_at: Date
  updated_at: Date
  , { versionKey: false }



UserSchema.index({user_id: 1}, {unique: true})

@User = M.model "User", (UserSchema
).pre 'save', update_timestamp


@Options = M.model "Options", (M.Schema

  messaging:
    type   : Boolean
    default: false
  pet      :
    type   : Boolean
    default: false
  smoker   :
    type   : Boolean
    default: false
  airConditioning   :
    type   : Boolean
    default: false
  specialAssistant  :
    type   : Boolean
    default: false
  luggage  :
    type   : Boolean
    default: false
  vip      :
    type   : Boolean
    default: false
  airport  :
    type   : Boolean
    default: false
  invoice  :
    type   : Boolean
    default: false
    #validate: (x) -> x.length > 4 and '@' in x

  created_at: Date
  updated_at: Date

).pre 'save', update_timestamp

@Place = M.model "Place", (M.Schema

  location:
    type : [Number]
    index: '2dsphere'

  country      : String
  locality     : String
  street       : String
  street_number: String
  floor        : String
  appartment    : String
  admin_1_code :
    type   : String
    default: ""


  created_at: Date
  updated_at: Date

).pre 'save', update_timestamp

OperationSchema = M.Schema

  nonce:
    type: M.Schema.ObjectId
    default: null

  operation_id   :
    type    : Number
    unique  : true
    required: true
    
  deletetrip:
    default: false

    type   : Boolean
  rtaxi_id       : Number
  status:
    default: 'PENDING'
    type   : String

  device: String

  amount: Number
  comments       : String

  assigned_at    : Date

  estimated_time :
    type: Number
    default: 5

  fare_calculator_discount:
    type: Number
    default: null

  is_web_user    :
    type: Boolean
    default: false

  is_corporate    :
    type: Boolean
    default: false

  finding_driver :
    type: Boolean
    default: false

  is_in_parking  :
    type: Boolean
    default: false

  business_model:
    type:String
    default:'GENERIC'

  option:
    type: M.Schema.ObjectId
    ref: 'Options'
    default:null

  place_from:
    type: M.Schema.ObjectId
    ref: 'Place'
    default:null

  driver:
    type: M.Schema.ObjectId
    ref: 'Driver'
    default:null

  user:
    type: M.Schema.ObjectId
    ref: 'User'
    default:null

  place_to:
    type: M.Schema.ObjectId
    ref: 'Place'
    default:null

  blacklisted_drivers:
    type:[Number]
    default:[]

  blacklisted_drivers_obj: [{
    type: M.Schema.ObjectId,
    ref: 'Driver' }]

  queue_drivers_obj: [{
    type: M.Schema.ObjectId,
    ref: 'Driver' }]

  queue_drivers:
    type:[Number]
    default:[]

  location:
    type : [Number]
    index: '2dsphere'
    #validate: (x) -> x.length > 4 and '@' in x

  queue_date    : Date
  assigned_at   : Date
  at_the_door_at: Date

  created_at: Date
  updated_at: Date


OperationSchema.index({operation_id: 1}, {unique: true})

@Operation = M.model "Operation", (OperationSchema
).pre 'save', update_timestamp


ChatMessageSchema = M.Schema

  sender_id     : Number
  rtaxi_id      : Number
  security_email: String
  sender_name   : String

  filename: String
  bytes   : String

  recipients:
    type:[Number]
    default:[]

  recipients_ack:
    type:[Number]
    default:[]
  # 0 broadcast, 1 one to one, 2 group,3 SocketMessage
  type:
    type   : Number
    default: 0
  #audio:0 1:message 2:image
  type_message:
    type   : Number
    default: 0
  # 0 operador, 1 driver
  type_user:
    type   : Number
    default: 0

  # 0 operador, 1 driver
  type_user_sender:
    type   : Number
    default: 0
  # 0 operador, 1 driver
  type_user_receiver:
    type   : Number
    default: 0
  status:
    type   : String
    default: 'PENDING'

  created_at: Date
  updated_at: Date

# ChatMessageSchema.index({filename: 1}, {unique: true})
# ChatMessageSchema.plugin(autoIncrement.mongoosePlugin)

@ChatMessage = M.model "ChatMessage", (ChatMessageSchema
).pre 'save', update_timestamp



PushMessageSchema = M.Schema
  rtaxi_id      : Number

  recipients:
    type:[Number]
    default:[]

  recipients_ack:
    type:[Number]
    default:[]

  message :
    type   : String
    default: ''
  # 0 broadcast, 1 one to one, 2 group,3 SocketMessage
  type:
    type   : Number
    default: 0

  status:
    type   : String
    default: 'PENDING'

  created_at: Date
  updated_at: Date

@PushMessage = M.model "PushMessage", (PushMessageSchema
).pre 'save', update_timestamp




ConversationSchema = M.Schema

  sender_id     : Number
  receiver_id   : Number
  created_at: Date
  updated_at: Date

# ChatMessageSchema.index({filename: 1}, {unique: true})

@Conversation = M.model "Conversation", (ConversationSchema
).pre 'save', update_timestamp




@Connection = M.model "Connection", (M.Schema

  db_id : String
  kind  : String
  type  : String

  created_at: Date
  updated_at: Date

).pre 'save', update_timestamp


@Payment = M.model "Payment", (M.Schema

  reference   : String
  merchant    : String
  environment : String
  status      : String
  currency    : String
  amount      : Number
  contract    : String
  pspReference: String
  consumed    :
    type: Boolean
    default: false

  created_at  : Date
  updated_at  : Date

).pre 'save', update_timestamp


@TextNotification = M.model "TextNotification", (M.Schema
  text  : String

  created_at: Date
  updated_at: Date

).pre 'save', update_timestamp

@OperationFlow = M.model "OperationFlow", (M.Schema
  operation_id  :
    type  : Number
    index:  true

  sent_to     : [
    driver_email : String,
    at_time  : Date]
  assigned_to :
    driver_email : String,
    at_time  : Date
  accepted_by :
    driver_email : String,
    at_time  : Date

  estimated_time_to_door : Number
  at_the_door_at  : Date
  ring_user_at    : [Date]
  on_board_at     : Date

  canceled_by_user_at:  Date
  canceled_by_driver_at : Date
  canceled_by_operator:
    operator : String,
    at_time  : Date

  finished_by_user_at : Date
  finished_by_driver_at : Date
  finished_by_operator:
    operator : String,
    at_time  : Date

  created_at  :
    type: Date
    expires: '7d'
    default: Date.now
  updated_at  : Date

).pre 'save', update_timestamp


@PositionLog = M.model "PositionLog", (M.Schema
  created_at:
    type: Date
    index: true

  {strict : false
  autoIndex: false }
).pre 'save', (next) ->
    @created_at = Date.now()
    next()

@DriverConnectionLog = M.model "DriverConnectionLog", (M.Schema

  location:
    type : [Number]
    index: '2dsphere'

  driver_id: Number
  status   : String

  created_at: Date
  updated_at: Date

).pre 'save', update_timestamp

@DriverOperationTopologyLog = M.model "DriverOperationTopologyLog", (M.Schema

  location:
    type : [Number]
    index: '2dsphere'

  driver_id       : Number
  rtaxi_id        : Number
  operation_id    : Number
  status          : String
  operation_status: String

  operation_charge_id:
    type   : Number
    default: 0

  time         :
    type   : Number
    default: 0

  distance     :
    type   : Number
    default: 0

  acum_time    :
    type   : Number
    default: 0

  acum_distance:
    type   : Number
    default: 0

  grace_acum_distance:
    type   : Number
    default: 0
  grace_acum_time:
    type   : Number
    default: 0

  second_loc:
    type : [Number]
    index: '2dsphere'

  processed_grace_distance:
    default: false
    type   : Boolean

  processed       :
    default: false
    type   : Boolean

  created_at: Date
  updated_at: Date

).pre 'save', update_timestamp

@DebugLog = M.model "DebugLog", (M.Schema
  created_at:
    type: Date
    index: true

  type      : String

  {strict : false
  autoIndex: false }
).pre 'save', (next) ->
  @created_at = Date.now()
  next()

@OperationLog = M.model "OperationLog", (M.Schema
  created_at:
    type: Date
    index: true

  operation_id:
    type: Number
    index: true

  actor  : String
  action : String
  ip     : String
  params : M.Schema.Types.Mixed

  { autoIndex: false }

).pre 'save', (next) ->
  @created_at = Date.now()
  next()

@ErrorLog = M.model "ErrorLog", (M.Schema
  created_at:
    type: Date
    index: true

  tag       : String
  exception : String
  func      : String
  params    : String
  message   : String
  stack     : String

  { autoIndex: false }

).pre 'save', (next) ->
  @created_at = Date.now()
  next()

exports.config = 
  seleniumAddress: "http://localhost:4444/wd/hub"
  specs: [
    "dispatcher/login-spec.js"

    #"booking/login-spec.js"
    #"booking/register-spec.js"
    #"booking/order-spec.js"
  ]
  onPrepare: ->
    global.By = global.by

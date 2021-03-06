strings1 = [
    "signup/js/config/locale.js",
    "signup/js/controllers/signupCtrl.js",
    "signup/js/services/api/apiHandler.js",
    "signup/js/services/api/apiAdapter.js",
    "signup/js/signup.js",
    "test/js/booking/register-spec.js",
    "test/js/booking/order-spec.js",
    "test/js/booking/login-spec.js",
    "test/js/config.js",
    "test/js/dispatcher/login-spec.js",
    "booking/js/config/routes.js",
    "booking/js/config/locale.js",
    "booking/js/controllers/bookingCtrl.js",
    "booking/js/booking.js",
    "booking/js/services/models/user.js",
    "booking/js/services/models/company.js",
    "booking/js/services/models/driver.js",
    "booking/js/services/models/order.js",
    "booking/js/services/api/apiHandler.js",
    "booking/js/services/api/apiAdapter.js",
    "booking/js/services/error.js",
    "booking/js/services/webSocket/webSocketHandler.js",
    "booking/js/services/webSocket/webSocketAdapter.js",
    "booking/js/directives/checkEmail.js",
    "landings/3/js/config/locale.js",
    "landings/3/js/controllers/landingCtrl.js",
    "landings/3/js/landing3.js",
    "landings/1/js/config/locale.js",
    "landings/1/js/landing1.js",
    "landings/1/js/controllers/landingCtrl.js",
    "landings/2/js/config/locale.js",
    "landings/2/js/controllers/landingCtrl.js",
    "landings/2/js/landing2.js",
    "dashboard/js/config/route.js",
    "dashboard/js/config/locale.js",
    "dashboard/js/controllers/dashboardCtrl.js",
    "dashboard/js/services/models/company.js",
    "dashboard/js/services/api/apiHandler.js",
    "dashboard/js/services/api/apiAdapter.js",
    "dashboard/js/services/grid.js",
    "dashboard/js/dashboard.js",
    "technorides/js/config/routes.js",
    "technorides/js/config/locale.js",
    "technorides/js/controllers/technoridesCtrl.js",
    "technorides/js/services/api/apiHandler.js",
    "technorides/js/services/api/apiAdapter.js",
    "technorides/js/services/fake-user.js",
    "technorides/js/services/fake-company.js",
    "technorides/js/services/map.js",
    "technorides/js/technorides.js",
    "common/js/feedback.js",
    "common/js/messages.js",
    "common/js/api/api.js",
    "common/js/websocket/webSocket.js",
    "common/js/settings.js",
    "common/js/versionDetector.js",
    "common/js/map.js",
    "login/js/config/locale.js",
    "login/js/controllers/loginCtrl.js",
    "login/js/services/models/user.js",
    "login/js/services/models/error.js",
    "login/js/services/api/apiHandler.js",
    "login/js/services/api/apiAdapter.js",
    "login/js/login.js",
    "dispatcher/js/config/route.js",
    "dispatcher/js/config/locale.js",
    "dispatcher/js/controllers/dispatcherCtrl.js",
    "dispatcher/js/services/radio.js",
    "dispatcher/js/services/models/company.js",
    "dispatcher/js/services/models/statistics.js",
    "dispatcher/js/services/models/error.js",
    "dispatcher/js/services/messages.js",
    "dispatcher/js/services/api/apiHandler.js",
    "dispatcher/js/services/api/apiAdapter.js",
    "dispatcher/js/services/menu.js",
    "dispatcher/js/services/websocket/websocketHandler.js",
    "dispatcher/js/services/websocket/websocketAdapter.js",
    "dispatcher/js/services/sugestions.js",
    "dispatcher/js/dispatcher.js",
    "dispatcher/js/directives/src-err.js",
    "dispatcher/js/filters/filterOperationByStatus.js",
    "dispatcher/js/filters/orderObject.js",
    "dispatcher/js/filters/timer.js",
]

strings2 = [
    "signup/css/signup.css",
    "booking/css/style.css",
    "landings/3/css/styles.css",
    "landings/1/css/styles.css",
    "landings/2/css/styles.css",
    "dashboard/css/dashboard.css",
    "technorides/css/styles.css",
    "login/css/login.css",
    "dispatcher/css/dispatcher.css",
]

for find in strings2:
    replace = find.replace('/css/', '/styles/')
    print ('''
        sed -i 's#%s#%s#g' $(find -type f -name '*.jade')
    ''' % (find, replace)).strip()
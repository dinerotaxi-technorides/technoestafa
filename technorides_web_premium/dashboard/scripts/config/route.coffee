technoridesApp.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/',
      templateUrl : 'views/dashboard.html'
      controller  : 'staticsCtrl'
    # History tabs
    .when '/history',
      templateUrl : 'views/history/history.html'

    .when '/history/scheduled',
      templateUrl : 'views/history/scheduled.html'
      controller : 'scheduledHistoryCtrl'


    .when '/inbox',
      templateUrl : 'views/inbox/list.html'
      controller  : 'inboxCtrl'

    .when '/passengers',
      templateUrl : 'views/passenger.html'
      controller  : 'passengersCtrl'

    .when '/corporate',
      templateUrl : 'views/corporate/corporate.html'
      controller  : 'corporateCtrl'

    #COMPANY
    .when '/corporate/:corpid',
      templateUrl : 'views/corporate/account.html'
      controller  : 'corpAccountCtrl'

    #COST CENTER
    .when '/corporate/:corpid/:costid',
      templateUrl : 'views/corporate/costcenter.html'
      controller  : 'costCenterCtrl'
    #CORP EMPLOYEES
    .when '/corporate/:corpid/:costid/employee/:employid',
      templateUrl : 'views/corporate/employee.html'
      controller  : 'employeeCtrl'
    #INVOICE
    .when '/corporate/:corpid/:costid/invoice/:invid',
      templateUrl : 'views/corporate/invoice/view.html'
      controller  : 'invoiceCtrl'
    # Edit
    .when '/corporate/:corpid/:costid/invoice/:invid/edit',
      templateUrl : 'views/corporate/invoice/edit.html'
      controller  : 'invoiceCtrl'
    # New
    .when '/corporate/:corpid/:costid/new',
      templateUrl : 'views/corporate/invoice/new.html'
      controller  : 'costCenterCtrl'

    .when '/profile',
      templateUrl : 'views/profile.html'
      controller  : 'profileCtrl'
    # Configuration Subtabs
    .when '/configuration/drivers',
      templateUrl : 'views/configuration/drivers.html'

    .when '/configuration/scheduled',
      templateUrl : 'views/configuration/scheduled.html'

    .when '/configuration/operations',
      templateUrl: 'views/configuration/operations.html'

    .when '/configuration/charges',
      templateUrl: 'views/configuration/payments.html'

    .when '/configuration/parkings',
      templateUrl: 'views/configuration/parkings.html'
      controller : 'parkingCtrl'

    .when '/configuration/fares',
      templateUrl: 'views/configuration/fares.html'
      controller  : 'faresCtrl'

    .when '/configuration/webpage',
      templateUrl : 'views/configuration/web.html'

    .when '/configuration/emails',
      templateUrl : 'views/configuration/emails.html'

    .when '/configuration/timezone',
      templateUrl : 'views/configuration/timezone.html'

    .when '/reports/operations-month',
      templateUrl : 'views/reports/operations.html'
      controller  : 'monthlyReportsCtrl'

    .when '/reports/drivers',
      templateUrl : 'views/reports/drivers.html'
      controller  : 'driversReportsCtrl'

    .when '/reports/operations-day',
      templateUrl : 'views/reports/day.html'
      controller  : 'dailyReportsCtrl'

    # Employees
    .when '/employees/operators',
      templateUrl : 'views/employees/operators/list.html'

    .when '/employees/drivers',
      templateUrl : 'views/employees/drivers/list.html'

    .when '/employees/driver/:id',
      controller  : 'driverProfileCtrl'
      templateUrl : 'views/employees/drivers/driver.html'

    .when '/employees/driver/:id/invoices',
      controller  : 'driverInvoiceCtrl'
      templateUrl : 'views/employees/drivers/invoices/list.html'

    .when '/employees/driver/:id/receipts',
      controller  : 'driverReceiptCtrl'
      templateUrl : 'views/employees/drivers/receipts/list.html'

    .when '/employees/driver/:id/history_invoices',
      controller  : 'driverHistoryInvoiceCtrl'
      templateUrl : 'views/employees/drivers/invoices/history_list.html'

    .when '/employees/driver/:id/history_receipts',
      controller  : 'driverHistoryReceiptCtrl'
      templateUrl : 'views/employees/drivers/receipts/history_list.html'

    .when '/employees/driver/:id/invoice/:invoice/edit',
      controller  : 'driverInvoiceCtrl'
      templateUrl : 'views/employees/drivers/invoices/edit.html'

    .when '/employees/driver/:id/new-invoice',
      controller  : 'driverInvoiceCtrl'
      templateUrl : 'views/employees/drivers/invoices/new.html'

    .otherwise
      redirectTo: '/'
]
.run ['$rootScope', '$location', '$cookieStore',($rootScope, $location, $cookieStore) ->

  $rootScope.$watch(
    ->
      $location.path()
    (path) ->
      $rootScope.activetab = path
    )
]

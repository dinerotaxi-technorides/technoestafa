technoridesApp.factory "$clients", ["clients.api", "$user", "$paginator", "$modal", "$sce", ($api, $user, $paginator, $modal, $sce) ->
  $clients =
    list : []
    searchFields: [
      "username",
      "companyName",
      "phone",
      "mailContacto"
    ]
    fields: [
      "companyName",
      # "createdDate",
      "username" ,
      # "password",
      "phone",
      "lang",
      "mailContacto",
      "cars",
      # "intervalPoolingTrip",
      # "intervalPoolingTripInTransaction",
      "latitude",
      "longitude",
      # "cuit",
      # "price",
      # "agree",
      # "enabled",
      # "accountLocked",
      # "isTestUser",
      # "cityName",
      # "wlconfigName"
      # 'id'
    ]
    get : (page, searchField, searchString, orderField, order) ->
      # Paginator
      if order?
        $clients.currentOrder = order
      else
        # New field
        if $clients.currentOrderField isnt orderField or $clients.currentOrder isnt "asc"
          $clients.currentOrderField = orderField?="username"
          $clients.currentOrder      = "asc"
        # Toggle (current field)
        else
          $clients.currentOrder = "desc"

      $api.get(
        data:
          token        : $user.token
          rows         : 10
          page         : page
          sidx         :  $clients.currentOrderField
          sord         :  $clients.currentOrder
          searchField  : searchField
          searchString : searchString?=""
        done : (response) ->
          $clients.list    = response.list
          $paginator.page  = response.page
          $paginator.pages = response.pages
        fail : (response) ->
          if response.status is 411
            $user.logout()
      )

    edit: (oper) ->
      $api.edit
        client : $clients.client
        oper : oper
        done : ->
          $modal.closeIt()
          $clients.unset()
          $clients.get(1)
          $clients.initForm()
        fail : ->



    set: (client, citiesList, configsList) ->
      $clients.client = client
      $clients.setSelectableCities(citiesList)
      $clients.setSelectableConfigs(configsList)

    unset: ->
      $clients.client = {}
      list: []
      client : {}
      view : {}

    setSelectableCities: (citiesList) ->
      for city in citiesList
        $clients.client.city = city.id if city.name is $clients.client.city

    setSelectableConfigs: (configsList) ->
      for config in configsList
        $clients.client.wlconfig = config.id if config.app is $clients.client.wlconfig

    initForm : () ->
        $clients.client.createdDate   = new Date()
        $clients.client.lang          = "es"
        $clients.client.cars          = 1
        $clients.client.intervalPoolingTrip = 20
        $clients.client.intervalPoolingTripInTransaction = 20
        $clients.client.latitude      = "0"
        $clients.client.longitude     = "0"
        $clients.client.cuit          = "0"
        $clients.client.price         = "1"
        $clients.client.agree         = false
        $clients.client.enabled       = false
        $clients.client.accountLocked = false
        $clients.client.isTestUser    = false
  ]

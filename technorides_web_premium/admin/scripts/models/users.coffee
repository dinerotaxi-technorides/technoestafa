technoridesApp.factory '$users', [ 'users.api', '$paginator', '$sce', '$modal', '$user' ,($api, $paginator, $sce, $modal, $user) ->
  $users =
    list : []
    searchFields: [
      "username",
      "lastName",
      "phone"
    ]
    fields: [
      "createdDate",
      # "rtaxi",
      "username",
      # "password",
      "firstName",
      "lastName",
      "phone",
      # "countTripsCompleted",
      # "isFrequent",
      # "status",
      # "agree",
      "enabled",
      "accountLocked",
      # "isTestUser",
      # "ip",
      "companyName",
      # "lang",
      # "city",
      # "id"
    ]

    get: (page, searchField, searchString, orderField, order) ->
        # Paginator
        if order?
          $cities.currentOrder = order
        else
          # New field
          if $user.currentOrderField isnt orderField or $user.currentOrder isnt "asc"
            $user.currentOrderField = orderField?="username"
            $user.currentOrder      = "asc"
          # Toggle (current field)
          else
            $user.currentOrder = "desc"

        $api.get
          data:
            token: $user.token
            rows: 10
            page: page
            sidx: $user.currentOrderField
            sord: $user.currentOrder
            searchField: searchField
            searchString: searchString
          done: (adapted) ->
            $users.list = adapted.list
            $paginator.page = adapted.page
            $paginator.pages = adapted.pages
          fail : (response) ->
            if response.status is 411
              $user.logout()

    edit : (oper) ->
      $api.edit
        user : $users.user
        oper : oper
        done : ->
          $modal.closeIt()
          $users.unset()
          $users.get(1)
        fail : ->

    set : (user, citiesList) ->
      $users.user = user
      $users.setSelectableCities(citiesList)

    setSelectableCities: (citiesList) ->
      for city in citiesList
        $users.user.city = city.id if city.name is $users.user.city


    unset: ->
        $users.user = {}
        list: []
        user : {}
        view :  {}
  ]

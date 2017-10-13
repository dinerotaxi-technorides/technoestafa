technoridesApp.factory "$cities", ["api.cities", "$user", "$paginator", "$modal", "$sce", ($api, $user, $paginator, $modal, $sce) ->
  $cities =
    list : []
    searchFields: [
      'name',
      'country',
      'timeZone'
    ]
    fields: [
      'name',
      'country',
      'admin1Code',
      'locality',
      'countryCode',
      'timeZone',
      # 'northEastLatBound',
      # 'northEastLngBound',
      # 'southWestLatBound',
      # 'southWestLngBound',
      'enabled',
      # 'id'
    ]
    get : (page, searchField, searchString, orderField, order) ->
      # Paginator
      if order?
        $cities.currentOrder = order
      else
        # New field
        if $cities.currentOrderField isnt orderField or $cities.currentOrder isnt "asc"
          $cities.currentOrderField = orderField?="name"
          $cities.currentOrder      = "asc"
        # Toggle (current field)
        else
          $cities.currentOrder = "desc"


      $api.get(
        data:
          token        : $user.token
          rows         : 10
          page         : page
          sidx         : $cities.currentOrderField
          sord         : $cities.currentOrder
          searchField  : searchField
          searchString : searchString
        done : (response) ->
          $cities.list = response.list
          $paginator.page = response.page
          $paginator.pages = response.pages
        fail : (response) ->
          if response.status is 411
            $user.logout()
      )

    getSelectableCities : ->
      $api.get(
        data:
          token: $user.token
          rows: 99999
          page: 0
          sidx: "name"
        done : (response) ->
          $cities.list = response.list
        fail : (response) ->
          if response.status is 411
            $user.logout()
      )

    edit: (oper) ->
      $api.edit
        city : $cities.city
        oper : oper
        done : ->
          $modal.closeIt()
          $cities.unset()
          $cities.get(1)
        fail : ->



    set: (city) ->
      $cities.city = city

    unset: ->
      $cities.city = {}
      list: []
      city : {}
      view : {}
  ]

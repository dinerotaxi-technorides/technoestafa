technoridesApp.factory '$marketing', [ 'marketing.api', '$paginator', '$sce', '$modal',($api, $paginator, $sce, $modal) ->
  $marketing =
    list:[]
    fields: [
      "name",
      "subject",
      # "body",
      # "language",
      # "user",
      # "isEnabled",
      # "id"
    ]
    showFields: [
      "name",
      "subject",
      "language",
      "user",
      "isEnabled",
      # "id"
    ]
    get : (page, searchField, searchString, orderField, order) ->
      # Paginator
      if order?
        $marketing.currentOrder = order
      else
        # New field
        if $marketing.currentOrderField isnt orderField or $marketing.currentOrder isnt "asc"
          $marketing.currentOrderField = orderField?="name"
          $marketing.currentOrder      = "asc"
        # Toggle (current field)
        else
          $marketing.currentOrder = "desc"

      $api.get
        data:
          searchField  : searchField
          searchString : searchString?=""
          sidx         : $marketing.currentOrderField
          sord         : $marketing.currentOrder
          page         : page
          rows         : 10
        done: (adapted) ->
          $marketing.list = adapted.list
          $paginator.page = adapted.page
          $paginator.pages = adapted.pages
        fail : (response) ->

    preview : (id) ->
      $api.preview
        id : id
        done : (adapted) ->
          $marketing.view = $sce.trustAsHtml adapted
        fail : (response) ->

    edit : (oper) ->
      $api.edit
        email : $marketing.email
        oper : oper
        done : ->
          $modal.closeIt()
          $marketing.unset()
          $marketing.get()
        fail : ->

    set : (email) ->
      $marketing.email = email
      $api.preview
        id : email.id
        done : (adapted) ->
          $marketing.email.body = $sce.trustAsHtml adapted
        fail : (response) ->

    unset: ->
      $marketing.email = {}
    list: []
    email : {}
    view : {}
]

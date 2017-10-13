technoridesApp.controller 'operationsCtrl', ($scope, $operations, $interval, $autocomplete, $map, $company, $filter, $modal, $user, $tutorial, $timeout, $chat, $paginator) ->
  $scope.chat = $chat
  $scope.operations = $operations
  $scope.modal = $modal
  $scope.user = $user
  $scope.paginator = $paginator
  $operations.getScheduled()
  # $scope.reason = ""
  $interval(->
    if $scope.menu.tab isnt "canceled"
      $scope.paginateNormal($paginator.page, $scope.menu.tab, $scope.searchString)
  ,
    1000
  ,
    0)
  $interval(->
    $operations.getScheduled($scope.menu.stab, $operations.scheduledPage)
  ,
    10000
  ,
    0)

  $scope.autocomplete = $autocomplete
  $scope.serverDate = "GMT -3" #moment(new Date()).zone("-0300").format("hh:mm")

  $scope.gotoPending = ->
    $tutorial.trigger 'go-to-pending'
  $scope.loadNewView = ->
    $tutorial.trigger('new-trip-visible')

  $scope.fillFormUserForm = (sugestion) ->
    $scope.operations.operation.user =
      phone   : sugestion.phone
      email   : sugestion.email
      surname : sugestion.last_name
      name    : sugestion.first_name
      id      : sugestion.user_id

    $scope.autocomplete.passengers = []


  # FIXME: Mover a modelos
  $scope.fillFormOriginFormWithFavorite = (favorite) ->
    $scope.operations.operation.addressFrom =
      address   : favorite.street
      floor     : favorite.floor
      apartment : favorite.department
    $scope.operations.operation.addressTo =
      address   : favorite.place_to.street


    latitude  = favorite.lat
    longitude = favorite.lng
    latLng    = $map.latLng {lat:latitude, lng:longitude}
    $map.setCenter latLng
    $map.updateMarker "newOperation", "from",
      visible  : true
      position : latLng

    unless favorite.place_to.lat is 0 or favorite.place_to.lng is 0
      latitude  = favorite.place_to.lat
      longitude = favorite.place_to.lng
      latLng    = $map.latLng {lat:latitude, lng:longitude}
      $map.setCenter latLng
      $map.updateMarker "newOperation", "to",
        visible  : true
        position : latLng

    $operations.calculatePrice()
    $scope.autocomplete.favorites = []

  # FIXME: Mover a modelos
  $scope.fillFormOriginForm = (place) ->
    $scope.operations.operation.addressFrom = address : place.placeName

    $scope.autocomplete.froms = undefined

  # FIXME: Mover a modelos
  $scope.fillFormDestinationForm = (place) ->
    $scope.operations.operation.addressTo = address : place.placeName

    $scope.autocomplete.tos = undefined


  $scope.resetNewOperationForm = ->
    $('[data-toggle="popover"]').popover()
    $autocomplete.passengers       = []
    $autocomplete.favorites        = []
    $autocomplete.froms            = undefined
    $autocomplete.tos              = undefined
    $operations.operation          = options : {}
    $operations.operation.executiontime = $company.configuration.operations.scheduled.executiontime
    newDate                        = new Date()
    $operations.operation.dateDay  = newDate
    $operations.operation.dateHour = newDate
    $operations.price              = undefined
    $map.updateMarker "newOperation", "from", {visible: false}
    $map.updateMarker "newOperation", "to", {visible: false}
    $map.clearRoute()
    newDate.setMinutes(Math.ceil(newDate.getMinutes() / 5) * 5)
    $scope.datepickerMinDate       = new Date()
    $scope.initFields()

  # Estimated Time
  $interval(->
    for id, operation of $operations.list
      operation.estimatedTime-- unless operation.atDoorAt? or operation.status is "pending"
  ,
    1000
  ,
    0
  ,
    true
  )

  $scope.setPagination = (tab) ->
    $scope.currentPage = 0
    $scope.numberOfPages(tab)

  $scope.paginateCanceled = (page, status) ->
    count = 0
    for op in $operations.list
      if op.originalStatus is status
        count++
    $paginator.updatePaginator page, count

  $scope.paginateNormal = (page, status, passengerEm) ->
    count = 0
    for op in $operations.list
      if op.status is status
        # FIXME Hardcoded status (Angular magic disabled)
        if  passengerEm is "" or op.passenger.email?.match passengerEm
          count++
    $paginator.updatePaginator page, count

  $scope.numberOfPages = (status, passengerEm) ->
    count = 0
    for op in $operations.list
      if op.status is status
        # FIXME Hardcoded status (Angular magic disabled)
        if  passengerEm is "" or op.passenger.email?.match passengerEm
          count++
    number = Math.ceil count/$scope.pageSize
    #$paginator.setTotalPages number
    _.range number

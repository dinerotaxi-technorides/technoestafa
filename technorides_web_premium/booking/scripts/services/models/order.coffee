technoridesApp.factory '$order', ($cookieStore, $company ,$api) ->

  $order =

    id : null

    getScheduledOperations : ->
      $api.send "getScheduledOperations"

    scheduledOperations : {}

    deleteScheduledOp : (id) ->
      $api.send "deleteScheduledOp", id, ->
        $order.getScheduledOperations()

    createTrip : (response) ->
      for key, value of response
        $order[key] = value
      $order.saveToCookies($order.id)


    cancel : ->
      $order.id     = null
      $order.status = "canceled"
      $order.saveToCookies($order.id)


    assign : ->
      $order.status = "assignedtaxi"


    finish : ->
      $order.id = null
      $order.status = "finished"
      $order.saveToCookies($order.id)


    driverArrived : ->
      $order.status = "arrived"
      $order.saveToCookies($order.id)


    loadFromCookies : ->
      $order.id = $cookieStore.get "booking_orderId_#{$company.rtaxi}"


    saveToCookies : (order) ->
      $cookieStore.put("booking_orderId_#{$company.rtaxi}", order)


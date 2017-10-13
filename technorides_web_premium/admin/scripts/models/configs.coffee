technoridesApp.factory "$configs", ["configs.api", "$user", "$paginator", "$modal", "$sce", ($api, $user, $paginator, $modal, $sce) ->
  $configs =
    list : []
    searchFields: [
      "app"
    ]

    fields:
      app:
        visible: true
        tab: 0
        type: "text"
      mapKey:
        visible: false
        tab: 0
        type: "text"
      #TAB 2 email api configuration sendgrid (client api use)
      mailkey:
        visible: false
        tab: 0
        type: "text"
      mailSecret:
        visible: false
        tab: 0
        type: "text"
      mailFrom:
        visible: false
        tab: 0
        type: "text"
      ##TAB 2  push notification android
      androidAccountType:
        visible: false
        tab: 1
        type: "text"
      androidEmail:
        visible: false
        tab: 1
        type: "text"
      androidPass:
        visible: false
        tab: 1
        type: "text"
      androidToken:
        visible: false
        tab: 1
        type: "text"
      ##TAB 2 push notification ios
      appleIp:
        visible: false
        tab: 1
        type: "text"
      applePort:
        visible: false
        tab: 1
        type: "number"
      appleCertificatePath:
        visible: false
        tab: 1
        type: "text"
      applePassword    :
        visible: false
        tab: 1
        type: "text"
      #apps url
      androidUrl:
        visible: false
        tab:  2
        type: "text"
      iosUrl:
        visible: false
        tab:  2
        type: "text"
      windowsPhoneUrl:
        visible: false
        tab:  2
        type: "text"
      bb10Url:
        visible: false
        tab:  2
        type: "text"
      #webpage configuration
      pageTitle:
        visible: false
        tab: 3
        type: "text"
      pageCompanyTitle:
        visible: false
        tab: 3
        type: "text"
      pageCompanyDescription:
        visible: false
        tab: 3
        type: "text"
      pageCompanyStreet:
        visible: false
        tab: 3
        type: "text"
      pageCompanyZipCode:
        visible: false
        tab: 3
        type: "text"
      pageCompanyState:
        visible: false
        tab: 3
        type: "text"
      pageCompanyLinkedin:
        visible: false
        tab: 3
        type: "text"
      pageCompanyFacebook:
        visible: false
        tab: 3
        type: "text"
      pageCompanyTwitter:
        visible: false
        tab: 3
        type: "text"
      pageCompanyWeb:
        visible: false
        tab: 3
        type: "text"
      pageCompanyLogo:
        visible: false
        tab: 3
        type: "text"
      #currency in the system
      currency:
        visible: false
        tab: 3
        type: "text"
      #trip configuration
      intervalPoolingTripInTransaction:
        visible: false
        tab: 4
        type: "number"
      intervalPoolingTrip:
        visible: false
        tab: 4
        type: "number"
      timeDelayTrip:
        visible: false
        tab: 4
        type: "number"
      distanceSearchTrip:
        visible: false
        tab: 4
        type: "number"
      percentageSearchRatio:
        visible: false
        tab: 4
        type: "number"

      disputeTimeTrip:
        visible: false
        tab: 4
        type: "number"
      isQueueTripActivated :
        visible: false
        tab: 4
        type: "checkbox"

      queueTripType:
        options:[
          "FIRST_TAKE",
          "BEST_DISTANCE",
          "BEST_TIME"
        ]
        visible: false
        # tab: 4
        type: "text"
      disputeTimeTrip:
        visible: false
        tab: 4
        type: "number"
      driverSearchTrip:
        visible: false
        tab: 4
        type: "number"
      #parking config
      parking:
        visible: false
        tab: 5
        type: "checkbox"
      parkingPolygon:
        visible: false
        tab: 5
        type: "checkbox"
      parkingDistanceDriver:
        visible: false
        tab: 5
        type: "number"
      parkingDistanceTrip:
        visible: false
        tab: 5
        type: "number"
      #driver payment configuration
      hasDriverPayment:
        visible: false
        tab: 6
        type: "checkbox"
      driverPayment:
        visible: false
        tab: 6
        type: "number"
      driverTypePayment:
        visible: false
        tab: 6
        type: "number"
      driverAmountPayment:
        visible: false
        tab: 6
        type: "number"
      driverCorporateCharge:
        visible: false
        tab: 8
        type: "number"

      digitalRadio:
        visible: false
        tab: 6
        type: "checkbox"
      #zones configuration
      hasRequiredZone:
        visible: false
        tab: 7
        type: "checkbox"
      hasRequiredKm:
        visible: false
        tab: 7
        type: "checkbox"
      hasMobilePayment:
        visible: false
        tab: 7
        type: "checkbox"
      hadUserNumber:
        visible: false
        tab: 7
        type: "checkbox"

      endlessDispatch:
        visible: false
        tab: 7
        type: "checkbox"

      useAdminCode:
        visible: false
        tab: 7
        type: "checkbox"

      merchantId:
        visible: false
        tab: 7
        type: "text"

      mobileCurrency:
        visible: false
        tab: 7
        type: "text"

      hasZoneActive:
        visible: false
        tab: 7
        type: "checkbox"

      costRute:
        visible: false
        tab: 7
        type: "number"
      costRutePerKm:
        visible: false
        tab: 7
        type: "number"
      costRutePerKmMin:
        visible: false
        tab: 7
        type: "number"

      sendNotification:
        visible: false
        tab: 7
        type: "checkbox"

      isEnable:
        visible: true
        tab: 7
        type: "checkbox"

      zoho:
        visible: false
        tab: 7
        type: "text"
      #driver show/hide options when dispatch trip
      newOpshowAddressFrom:
        visible: false
        tab: 8
        type: "checkbox"
      newOpshowAddressTo:
        visible: false
        tab: 8
        type: "checkbox"
      newOpshowCorporate:
        visible: false
        tab: 8
        type: "checkbox"
      newOpshowUserName:
        visible: false
        tab: 8
        type: "checkbox"
      newOpshowUserPhone:
        visible: false
        tab: 8
        type: "checkbox"
      newOpshowOptions:
        visible: false
        tab: 8
        type: "checkbox"
      newOpComment:
        visible: false
        tab: 8
        type: "checkbox"

      driverCancelTrip:
        visible: false
        tab: 8
        type: "checkbox"

      passengerDispatchMultipleTrips:
        visible: false
        tab: 8
        type: "checkbox"
      operatorDispatchMultipleTrips:
        visible: false
        tab: 8
        type: "checkbox"

      operatorSuggestDestination:
        visible: false
        tab: 8
        type: "checkbox"

      blockMultipleTrips:
        visible:  false
        tab:  8
        type:"checkbox"

      hasDriverDispatcherFunction:
        visible: false
        tab: 8
        type: "checkbox"
      #fare calculator options
      isPrePaidActive:
        tab: 9
        type: "checkbox"
      isFareCalculatorActive:
        visible: false
        tab: 9
        type: "checkbox"
      fareInitialCost:
        visible: false
        tab: 9
        type: "number"
      fareCostPerKm:
        visible: false
        tab: 9
        type: "number"
      isChatEnabled:
        visible: false
        tab: 9
        type: "checkbox"
      fareConfigActivateTimePerDistance:
        visible: false
        tab: 9
        type: "number"
      fareConfigTimeInitialSecWait:
        visible: false
        tab: 9
        type: "number"
      fareConfigTimeSecWait:
        visible: false
        tab: 9
        type: "number"
      fareCostTimeWaitPerXSeg:
        visible: false
        tab: 9
        type: "number"
      fareCostTimeInitialSecWait:
        visible: false
        tab: 9
        type: "number"
      # id:
      #   visible: false
      #   tab: -1
      #   type: "text"


    get : (page, searchField, searchString, orderField, order) ->
        # Paginator
      if order?
        $configs.currentOrder = order
      else
        # New field
        if $configs.currentOrderField isnt orderField or $configs.currentOrder isnt "asc"
          $configs.currentOrderField = orderField?="app"
          $configs.currentOrder      = "asc"
        # Toggle (current field)
        else
          $configs.currentOrder = "desc"


      $api.get(
        data:
          token        : $user.token
          rows         : 10
          page         : page
          sidx         : $configs.currentOrderField
          sord         : $configs.currentOrder
          searchField  : searchField
          searchString : searchString?=""
        done : (response) ->
          $configs.list = response.list
          $paginator.page = response.page
          $paginator.pages = response.pages
        fail : (response) ->
          if response.status is 411
            $user.logout()
      )

    getWlconfigs : ->
      $api.get(
        data:
          token: $user.token
          rows: 99999
          page: 0
          sidx: "app"
        done : (response) ->
          $configs.list = response.list
        fail : (response) ->
          if response.status is 411
            $user.logout()
      )

    edit: (oper) ->
      $api.edit
        config : $configs.config
        fields : $configs.fields
        oper : oper
        id : $configs.config.id
        done : ->
          $modal.closeIt()
          $configs.unset()
          $configs.get(1)
        fail : ->



    set: (config) ->
      $configs.config = config

    unset: ->
      $configs.config = {}
      list: []
      config : {}
      view : {}
  ]

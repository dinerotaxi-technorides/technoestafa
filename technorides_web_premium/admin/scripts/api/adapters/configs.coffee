technoridesApp.factory "configs.api", ($settings, $api, $user) ->

    $apiUrl    = $settings[$settings.environment].api
    $newApiUrl = $settings[$settings.environment].newApi

    api =
      get : (params) ->
        $api.get
          data      : params.data
          url       : "#{$apiUrl}technoRidesAdminApi/jq_configuration_app_list"
          done      : (response) ->
            adapted =
              list : []
              page : response.page
              pages : _.range response.total
            for row in response.rows
              adapted.list.push
                app                               :row.app
                mapKey                            :row.mapKey
                mailkey                           :row.mailkey
                mailSecret                        :row.mailSecret
                mailFrom                          :row.mailFrom
                androidAccountType                :row.androidAccountType
                androidEmail                      :row.androidEmail
                androidPass                       :row.androidPass
                androidToken                      :row.androidToken
                appleIp                           :row.appleIp
                applePort                         :row.applePort
                appleCertificatePath              :row.appleCertificatePath
                applePassword                     :row.applePassword
                androidUrl                        :row.androidUrl
                iosUrl                            :row.iosUrl
                windowsPhoneUrl                   :row.windowsPhoneUrl
                bb10Url                           :row.bb10Url
                pageTitle                         :row.pageTitle
                pageCompanyTitle                  :row.pageCompanyTitle
                pageCompanyDescription            :row.pageCompanyDescription
                pageCompanyStreet                 :row.pageCompanyStreet
                pageCompanyZipCode                :row.pageCompanyZipCode
                pageCompanyState                  :row.pageCompanyState
                pageCompanyLinkedin               :row.pageCompanyLinkedin
                pageCompanyFacebook               :row.pageCompanyFacebook
                pageCompanyTwitter                :row.pageCompanyTwitter
                pageCompanyWeb                    :row.pageCompanyWeb
                pageCompanyLogo                   :row.pageCompanyLogo
                currency                          :row.currency
                intervalPoolingTripInTransaction  :row.intervalPoolingTripInTransaction
                intervalPoolingTrip               :row.intervalPoolingTrip
                timeDelayTrip                     :row.timeDelayTrip
                distanceSearchTrip                :row.distanceSearchTrip
                percentageSearchRatio             :row.percentageSearchRatio
                driverSearchTrip                  :row.driverSearchTrip
                parking                           :row.parking
                parkingPolygon                    :row.parkingPolygon
                parkingDistanceDriver             :row.parkingDistanceDriver
                parkingDistanceTrip               :row.parkingDistanceTrip
                hasDriverPayment                  :row.hasDriverPayment
                driverPayment                     :row.driverPayment
                driverTypePayment                 :row.driverTypePayment
                driverAmountPayment               :row.driverAmountPayment
                digitalRadio                      :row.digitalRadio
                hasRequiredZone                   :row.hasRequiredZone
                hasRequiredKm                     :row.hasRequiredKm
                hasMobilePayment                  :row.hasMobilePayment
                hadUserNumber                     :row.hadUserNumber
                endlessDispatch                   :row.endlessDispatch
                useAdminCode                      :row.useAdminCode
                merchantId                        :row.merchantId
                mobileCurrency                    :row.mobileCurrency
                hasZoneActive                     :row.hasZoneActive
                costRute                          :row.costRute
                costRutePerKm                     :row.costRutePerKm
                costRutePerKmMin                  :row.costRutePerKmMin
                sendNotification                  :row.sendNotification
                operatorCancelationReason         :row.operatorCancelationReason
                isEnable                          :row.isEnable
                zoho                              :row.zoho
                newOpshowAddressFrom              :row.newOpshowAddressFrom
                newOpshowAddressTo                :row.newOpshowAddressTo
                newOpshowCorporate                :row.newOpshowCorporate
                newOpshowUserName                 :row.newOpshowUserName
                newOpshowUserPhone                :row.newOpshowUserPhone
                newOpshowOptions                  :row.newOpshowOptions
                newOpComment                      :row.newOpComment
                driverCancelTrip                  :row.driverCancelTrip
                passengerDispatchMultipleTrips    :row.passengerDispatchMultipleTrips
                operatorDispatchMultipleTrips     :row.operatorDispatchMultipleTrips
                operatorSuggestDestination        :row.operatorSuggestDestination
                blockMultipleTrips                :row.blockMultipleTrips
                hasDriverDispatcherFunction       :row.hasDriverDispatcherFunction
                isFareCalculatorActive            :row.isFareCalculatorActive
                isPrePaidActive                   :row.isPrePaidActive
                fareInitialCost                   :row.fareInitialCost
                fareCostPerKm                     :row.fareCostPerKm
                fareConfigActivateTimePerDistance :row.fareConfigActivateTimePerDistance
                fareConfigTimeInitialSecWait      :row.fareConfigTimeInitialSecWait
                fareConfigTimeSecWait             :row.fareConfigTimeSecWait
                fareCostTimeWaitPerXSeg            :row.fareCostTimeWaitPerXSeg
                fareCostTimeInitialSecWait        :row.fareCostTimeInitialSecWait
                disputeTimeTrip                   :row.disputeTimeTrip
                isQueueTripActivated              :row.isQueueTripActivated
                queueTripType                     :row.queueTripType
                driverCorporateCharge             :row.driverCorporateCharge
                isChatEnabled                     :row.isChatEnabled
                id                                : row.id
            params.done adapted
          fail      : (response) ->
            params.fail response


      edit : (params) ->
        data =
          oper        : params.oper
          token       : $user.token
          id          : params.id

        for field, fieldSettings of params.fields
          data[field] = params.config[field] unless params.config[field] is ""

        $api.get
          url : "#{$apiUrl}technoRidesAdminApi/jq_configuration_app_edit"
          code : "OK"
          codeName : "state"
          data : data
          done: (response) ->
            params.done()
          fail: (response) ->

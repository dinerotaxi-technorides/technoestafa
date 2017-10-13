technoridesApp.factory '$corporate', [ 'corporate.api','$location','$translate', '$map', '$modal' , '$rootScope', ($api, $location, $translate, $map, $modal, $rootScope) ->
  geocoder = new google.maps.Geocoder()
  $corporate =
    costCenter : {}

    getCompanyInfo : ->
      $api.getCompanyInfo
        done : (adapted) ->
          $corporate.company = adapted
          $corporate.terms.get()
          $corporate.lateFees.get()
          $corporate.taxes.get()



    addCostCenter : (costCenter) ->
      $api.addCostCenter
        costCenter : costCenter
        done : ->
          $modal.closeIt()
          $corporate.costCenters.get()
        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            $modal.open
              temp : "views/modal/corporate/new-cost-center-error.html"
              title : "Error"

    editCostCenter : (costCenter) ->
      $api.editCostCenter
        costCenter : costCenter
        done : ->
          $modal.closeIt()
          $corporate.costCenters.get()
        fail : (response) ->
          if response.status is 411
            $user.logout()
          else
            $modal.open
              temp : "views/modal/corporate/new-cost-center-error.html"
              title : "Error"

    getCostCenter: (id) ->
      $api.getCostCenter
        id : id
        done : (adapted) ->
          $corporate.costCenter = adapted
          $corporate.terms.get()
          $corporate.lateFees.get()
          $corporate.taxes.get()

    costCenters :
      list : []
      pages: []
      get : (page, search)  ->
        $api.getCostCenters
          page : page?=1
          done : (adapted) ->
            $corporate.costCenters.list = adapted.list
            $corporate.costCenters.pages = adapted.pages
            $corporate.costCenters.page = adapted.page

    company : {}

    invoice : {}

    invoices :
      print : ->
        window.print()
      list : []
      page : 1
      pages : []
      informPayment : (payment) ->
        $api.pay
          payment : payment
          done : ->
            $("#async").modal("hide")
      get : (page, search,orderBy,filterBy) ->
        if orderBy? and orderBy isnt ""
          orderBy = orderBy.split("-")
          order = orderBy[0]
          sort = orderBy[1]

        $api.getInvoices
          order  : order?=""
          sort   : sort?=""
          search : search?=""
          filter : filterBy?=""
          page   : page?=1
          done : (adapted) ->
            $corporate.invoices.list = adapted.list
            $corporate.invoices.page = adapted.page
            $corporate.invoices.pages = _.range adapted.pages-1
      view : (id) ->
        $api.viewInvoice
          id : id
          done : (adapted) ->
            $corporate.invoice = adapted

    operations :
      list : []
      page : 1
      pages : []
      get : (page, search, orderBy, filter) ->
        if orderBy? and orderBy isnt ""
          orderBy = orderBy.split("-")
          order = orderBy[0]
          sort = orderBy[1]
        $api.getOperations
          page : page?=1
          order : order?=""
          sort  : sort?=""
          filter : filter?=""
          search : search?=""

          done : (adapted) ->
            $corporate.operations.list = adapted.list
            $corporate.operations.page = adapted.page
            $corporate.operations.pages = _.range adapted.pages-1

    operation : {}

    taxes:
      list: {}
      get : ->
        $api.getTaxes
          done : (adapted) ->
            $corporate.taxes.list = adapted

    terms :
      list : {}
      get : ->
        $api.getTerms
          done : (adapted) ->
            $corporate.terms.list = adapted

    lateFees :
      list : {}
      get : ->
        $api.getLateFees
          done : (adapted) ->
            $corporate.lateFees.list = adapted

    setLocation : ->
      $map.getAddress  "#{$corporate.company.legalAddress}", (results) ->
        $map.provider.map = null
        $map.initialize "map_canvas",
          latitude  : 0
          longitude : 0
          zoom      : 16
          mapTypeId : "mapbox.streets"
          disableDefaultUI : true

        lat = results.geometry.location.lat
        lng = results.geometry.location.lng

        $map.setCenter $map.latLng {lat:lat, lng:lng}
        options =
          position : $map.latLng {lat:lat, lng:lng}
          icon     : "/common/assets/markers/cost-center.png"
          visible  : true
          draggable   : true

        events =
          event : "dragend"
          callback : (marker) ->

            latLng = $map.getCallbackMarker(marker)
            coords = $map.formatLatLng latLng
            $map.reverseGeolocalize {lat:coords.lat, lng:coords.lng}, (address) ->
              $corporate.company.legalAddress = "#{address}"
              $corporate.changed()

        $map.addMarker "costCenter", $corporate.company.name, options, [events]

    updateLocation : ->
      $map.getAddress "#{$corporate.company.legalAddress}", (results) ->
        lat = results.geometry.location.lat
        lng = results.geometry.location.lng

        options =
          position : $map.latLng({lat:lat,lng:lng})
          icon     : "/common/assets/markers/cost-center.png"
          visible  : true

        $map.addOrUpdateMarker "costCenter", $corporate.company.name, options
        $map.setCenter $map.latLng({lat:lat, lng:lng})

    edit : ->
      $api.edit
        corp : $corporate.company
        done : ->
          $modal.open(
            temp : "views/modal/corporate/profile-changed.html"
            title : "Congrats!"
          )

        fail : ->
          $modal.open(
            temp : "views/modal/corporate/profile-error.html"
            title : "Error"
          )

    changed : ->
      $rootScope.$broadcast 'corporateChanged'

]

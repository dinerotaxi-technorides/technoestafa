technoridesApp.controller 'citiesCtrl', ($scope, $settings, $cities, $user, $paginator) ->
  link = $settings[$settings.environment].api

  $scope.cities = $cities

  $paginator.model = $cities
  $paginator.get 1

  # jQuery("#contactGrid").jqGrid({
  #   url: "#{link}technoRidesAdminApi/jq_enabled_cities_list?token=#{$user.token}"
  #   editurl: "#{link}technoRidesAdminApi/jq_enabled_cities_edit?token=#{$user.token}"
  #   colNames: ['name','country','admin1Code','locality','countryCode','timeZone','northEastLatBound','northEastLngBound','southWestLatBound','southWestLngBound','enabled','id']
  #   colModel: [
  #     {name:'name', editable:true,editrules:{required:true}}
  #     {name:'country',editable:true,editrules:{required:true}},
  #     {name:'admin1Code',editable:true,editrules:{required:true}}
  #     {name:'locality',editable:true,editrules:{required:true}}
  #     {name:'countryCode',editable:true,editrules:{required:true}}
  #     {name:'timeZone',editable:true,editrules:{required:true}},
  #     {name:'northEastLatBound',editable:true,editrules:{required:true,number:true}}
  #     {name:'northEastLngBound',editable:true,editrules:{required:true,number:true}}
  #     {name:'southWestLatBound',editable:true,editrules:{required:true,number:true}}
  #     {name:'southWestLngBound',editable:true,editrules:{required:true,number:true}}
  #     {name:'enabled',   editable:true,  editrules:{required:true},edittype:'checkbox' }
  #     {name:'id',hidden:true}]
  #   sortname: 'name'
  #   caption: 'Ciudades Habilitadas'
  #   height: 300
  #   autowidth: true
  #   scrollOffset: 0
  #   viewrecords: true
  #   pager: '#contactGridPager'
  #   datatype: 'json'
  #   mtype: "GET"
  #   loadError: (jqXHR, textStatus, errorThrown) ->
  #     if jqXHR.status is 411
  #       $user.logout()
  #   })
  # $('#contactGrid').navGrid('#contactGridPager', {
  #   add: true
  #   edit: true
  #   del: true
  #   search: false
  #   refresh: true
  # })

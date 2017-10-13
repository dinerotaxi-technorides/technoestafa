technoridesApp.controller 'configsCtrl', ($settings, $user, $configs, $scope, $paginator) ->
  link = $settings[$settings.environment].api

  $scope.configs = $configs
  $paginator.model = $configs
  $paginator.get(1)

  # $("#configNotifGrid").jqGrid({
  #   url: "#{link}technoRidesAdminApi/jq_configuration_app_list?token=#{$user.token}"
  #   editurl: "#{link}technoRidesAdminApi/jq_configuration_app_edit?token=#{$user.token}"
  #   colNames: ['app','mailkey','mailSecret','mailFrom','androidAccountType','androidEmail','androidPass','androidToken','appleIp','applePort','appleCertificatePath','applePassword','androidUrl','iosUrl','windowsPhoneUrl','bb10Url','intervalPoolingTrip','intervalPoolingTripInTransaction','timeDelayTrip','distanceSearchTrip','driverSearchTrip','percentageSearchRatio','isEnable','digitalRadio', 'hasRequiredZone','hasZoneActive','costRute','ctRuteKm','ctRuteKmMin','zoho','mobilePayment','id']
  #   colModel: [
  #       {name:'app', editable:true,editrules:{required:true}}
  #       {name:'mailkey', editable:true,editrules:{required:true}}
  #       {name:'mailSecret', editable:true,editrules:{required:true}}
  #       {name:'mailFrom', editable:true,editrules:{required:true}},
  #       {name:'androidAccountType', editable:true,editrules:{required:true}},
  #       {name:'androidEmail', editable:true,editrules:{required:true}},
  #       {name:'androidPass', editable:true,editrules:{required:true}},
  #       {name:'androidToken', editable:true,editrules:{required:true}},
  #       {name:'appleIp', editable:true,editrules:{required:true}},
  #       {name:'applePort', editable:true,editrules:{required:true,integer:true}},
  #       {name:'appleCertificatePath', editable:true,editrules:{required:true}},
  #       {name:'applePassword', editable:true,editrules:{required:true}},
  #       {name:'androidUrl', editable:true,editrules:{required:true}},
  #       {name:'iosUrl', editable:true,editrules:{required:true}},
  #       {name:'windowsPhoneUrl', editable:true,editrules:{required:true}},
  #       {name:'bb10Url', editable:true,editrules:{required:true}},
  #       {name:'intervalPoolingTrip', editable:true,editrules:{required:true}},
  #       {name:'intervalPoolingTripInTransaction', editable:true,editrules:{required:true}},
  #       {name:'timeDelayTrip', editable:true,editrules:{required:true}},
  #       {name:'distanceSearchTrip', editable:true,editrules:{required:true}},
  #       {name:'driverSearchTrip', editable:true,editrules:{required:true}},
  #       {name:'percentageSearchRatio', editable:true,editrules:{required:true}},
  #
  #       {name:'isEnable',   editable:true,  editrules:{required:true},edittype:'checkbox' },
  #       {name:'digitalRadio',   editable:true,  editrules:{required:true},edittype:'checkbox' },
  #       {name:'hasRequiredZone',   editable:true,  editrules:{required:true},edittype:'checkbox' },
  #       {name:'hasZoneActive',   editable:true,  editrules:{required:true},edittype:'checkbox' },
  #       {name:'costRute', editable:true,editrules:{required:false}},
  #       {name:'costRutePerKm', editable:true,editrules:{required:false}},
  #       {name:'costRutePerKmMin', editable:true,editrules:{required:false}},
  #       {name:'zoho', editable:true,editrules:{required:true}},
  #       {name:'hasMobilePayment',   editable:true,  editrules:{required:true},edittype:'checkbox' },
  #       {name:'id',hidden:true}
  #     ]
  #   sortname: 'app'
  #   caption: 'Configuracion de empresa'
  #   height: 300
  #   autowidth: true
  #   scrollOffset: 0
  #   viewrecords: true
  #   pager: '#configNotifGridPager'
  #   datatype: 'json'
  #   loadError: (jqXHR, textStatus, errorThrown) ->
  #     if jqXHR.status is 411
  #       $user.logout()
  #   });
  # $('#configNotifGrid').navGrid('#configNotifGridPager', {
  #   add: true,
  #   edit: true,
  #   del: true,
  #   search: false,
  #   refresh: true
  # });
  # $(window).resize(->
  #   $('#configNotifGrid').fluidGrid({
  #     base:'#configNotifWrapper'
  #     offset: -2
  #   })
  # )

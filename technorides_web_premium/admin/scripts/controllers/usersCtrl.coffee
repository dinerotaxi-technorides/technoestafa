technoridesApp.controller 'usersCtrl', ($settings, $user, $scope , $users, $cities, $paginator) ->
  link = $settings[$settings.environment].api

  $scope.users  = $users
  $scope.cities = $cities
  $scope.cities.getSelectableCities()

  $paginator.model = $users
  $paginator.get 1

  # jQuery("#contactGrid").jqGrid({
  #   url: "#{link}technoRidesAdminApi/jq_real_user_serching_list?token=#{$user.token}"
  #   editurl: "#{link}technoRidesAdminApi/jq_edit_real_user?token=#{$user.token}"
  #   colNames: ['Created Date','RTX','UserName','Password','Nombre','Apellido','Telefono','Viajes','Frecuent','Tipo','Agree','Habilitado','Cuenta Bloqueada','isTestUser','ip','CP','lang','city','id']
  #   colModel: [
  #     {
  #       name:'createdDate'
  #       editable:false
  #       editrules:
  #         required:true
  #     }
  #     {
  #       name:'rtaxi'
  #       editable:false
  #       editable:false
  #       editrules:
  #         required:true
  #         search:false
  #     }
  #     {
  #       name:'username'
  #       editable:true
  #       editrules:
  #         required:true
  #         email:true
  #     }
  #     {
  #       name:'password'
  #       edittype:'password'
  #       editable:true
  #       editrules:
  #         required:true
  #       viewable: false
  #       search:false
  #       }
  #       {
  #         name:'firstName'
  #         editable:true
  #         editrules:
  #           required:true
  #         search:false
  #       }
  #       {
  #         name:'lastName'
  #         editable:true
  #         editrules:
  #           required:true
  #         search:false
  #       }
  #       {
  #         name:'phone'
  #         editable:true
  #         editrules:
  #           required:true
  #         editoptions:
  #           size:10
  #           manlength: 3
  #         search:false
  #       }
  #       {
  #         name:'countTripsCompleted'
  #         editable:false
  #         search:false
  #       }
  #       {
  #         name:'isFrequent'
  #         editable:true
  #         editrules:
  #           required:true
  #         edittype:'checkbox'
  #         search:false
  #       }
  #       {
  #         name:'status'
  #         index:'status'
  #         width:200
  #         sortable:false
  #         editable:true
  #         edittype:'select'
  #         editrules:
  #           required:true
  #         editoptions:
  #           dataUrl:"#{link}/technoRidesAdminApi/jq_get_status?token=#{$user.token}"
  #         search:false
  #       },
  #       {name:'agree', editable:true,  editrules:{required:true} ,edittype:'checkbox' ,search:false},
  #       {name:'enabled',   editable:true,  editrules:{required:true},edittype:'checkbox' ,search:false},
  #       {name:'accountLocked',   editable:true,  editrules:{required:true},edittype:'checkbox',search:false },
  #       {name:'isTestUser',   editable:true,  editrules:{required:true},edittype:'checkbox' ,search:false},
  #       {name:'ip', editable:false,search:false},
  #       {name:'companyName', editable:false,search:false},
  #       {name:'lang', editable:true,editrules:{required:true},search:false},
  #       {name:'city', width:200, sortable:false, editable:true, edittype:'select'  , editrules:{required:true},editoptions:{dataUrl:"#{link}/technoRidesAdminApi/jq_get_city?token=#{$user.token}"},search:false},
  #       {name:'id',hidden:true}
  #     ]
  #   sortname: 'firstName'
  #   caption: 'Usuarios'
  #   height: 300
  #   autowidth: true
  #   scrollOffset: 0
  #   viewrecords: true
  #   pager: '#contactGridPager'
  #   datatype: 'json'
  #   loadError: (jqXHR, textStatus, errorThrown) ->
  #     if jqXHR.status is 411
  #       $user.logout()
  #   })
  # $('#contactGrid').navGrid('#contactGridPager', {
  #   add: false,
  #   edit: true,
  #   del: false,
  #   search: true,
  #   refresh: true
  # });

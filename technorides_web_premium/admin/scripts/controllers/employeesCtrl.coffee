technoridesApp.controller 'employeesCtrl', ($scope, $settings, $employees, $user, $cities, $paginator) ->
  link = $settings[$settings.environment].api

  $scope.employees = $employees
  $paginator.model = $employees
  $paginator.get 1
  $scope.cities = $cities
  $scope.cities.getSelectableCities()


  # $("#contactGrid").jqGrid({
  #   url: "#{link}technoRidesAdminApi/jq_employee_list?token=#{$user.token}"
  #   editurl: "#{link}technoRidesAdminApi/jq_edit_customer?=token#{$user.token}"
  #   colNames: ['UserName','Password','Nombre','Apellido','Telefono','Tipo','Agree','Habilitado','Cuenta Bloqueada','isTestUser','ciudad','id']
  #   colModel: [
  #     {name:'username', editable:true,editrules:{required:true,email:true}},
  #     {name:'password', edittype:'password',editable:true,editrules:{required:true}, viewable: false,search:false},
  #     {name:'firstName',editable:true,editrules:{required:true},search:false},
  #     {name:'lastName', editable:true,editrules:{required:true},search:false},
  #     {name:'phone', editable:true, editrules:{required:true} ,editoptions: {size:10, manlength: 3},search:false},
  #     {name:'typeEmploy',index:'typeEmploy', width:200, sortable:false,editable:true, edittype:'select', editrules:{required:true}, editoptions:{dataUrl:"#{link}technoRidesAdminApi/jq_get_type?token=#{$user.token}"},search:false},
  #     {name:'agree', editable:true,  editrules:{required:true} ,edittype:'checkbox' ,search:false},
  #     {name:'enabled',   editable:true,  editrules:{required:true},edittype:'checkbox' ,search:false},
  #     {name:'accountLocked',   editable:true,  editrules:{required:true},edittype:'checkbox',search:false },
  #     {name:'isTestUser',   editable:true,  editrules:{required:true},edittype:'checkbox',search:false },
  #     {name:'city', width:200, editable:false,search:false},
  #     {name:'id',hidden:true}]
  #   sortname: 'firstName'
  #   caption: 'Empleados De Empresas'
  #   height: 300
  #   autowidth: true
  #   scrollOffset: 0
  #   viewrecords: true
  #   pager: '#contactGridPager'
  #   datatype: 'json'
  #   loadError: (jqXHR, textStatus, errorThrown) ->
  #     if jqXHR.status is 411
  #       $user.logout()
  # });
  # $('#contactGrid').navGrid('#contactGridPager', {
  #   add: false,
  #   edit: true,
  #   del: false,
  #   search: true,
  #   refresh: true
  # });

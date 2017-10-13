technoridesApp.controller 'emarketingCtrl', ($settings, $user, $marketing, $scope, $paginator) ->
  link = $settings[$settings.environment].api
  $scope.marketing = $marketing
  $paginator.model = $marketing

  $paginator.get(1)
  # $("#onlinenotificationGrid").jqGrid({
  #   url: "#{link}technoRidesAdminApi/jq_email_config_list?token=#{$user.token}"
  #   editurl: "#{link}technoRidesAdminApi/jq_email_config_edit?token=#{$user.token}"
  #   colNames: ['Name','Subject','Body','Lang','User','isEnabled','id']
  #   colModel: [
  #     {name:'name', editable:true,editrules:{required:true}}
  #     {name:'subject', editable:true,editrules:{required:true}},
  #     {name:'body',index:'body',editable:true,editrules:{required:true},edittype:'textarea', editoptions:{rows:'14',cols:'40',dataUrl:"#{link}technoRidesAdminApi/jq_email_body?token=#{$user.token}"}},
  #     {name:'lang', editable:true,editrules:{required:true}},
  #     {name:'user', editable:false},
  #     {name:'isEnabled',  editable:true,  editrules:{required:true},edittype:'checkbox' },
  #     {name:'id',hidden:true}
  #   ]
  #   sortname: 'name'
  #   caption: 'Email Configuration'
  #   height: 300
  #   autowidth: true
  #   scrollOffset: 0
  #   viewrecords: true
  #   pager: '#onlinenotificationGridPager'
  #   datatype: 'json'
  #   loadError: (jqXHR, textStatus, errorThrown) ->
  #     if jqXHR.status is 411
  #       $user.logout()
  #   })
  #
  # $('#onlinenotificationGrid').navGrid('#onlinenotificationGridPager', {
  #   add: true,
  #   edit: true,
  #   del: true,
  #   search: false,
  #   refresh: true
  # });
  # $(window).resize(->
  #   $('#onlinenotificationGrid').fluidGrid({
  #         base:'#onlinenotificationWrapper',
  #         offset: -2
  #   });
  # )
  # isAlphabet = (value, colname) ->
  #   alphaExp = /^[0-9a-zA-Z]+$/;
  #   if value.match(alphaExp)
  #     return [true,""];
  #   else
  #     return [false,"Solo se puede escribir Letras o numeros en la columna "+colname];
  #
  # afterSubmitEvent = (response, postdata) ->
  #   success = true;
  #   console.log ('here')
  #   json = eval('(' + response.responseText + ')')
  #   message = json.message
  #
  #   if json.state == 'FAIL'
  #     success = false;
  #   else
  #     $('#message').html(message);
  #     $('#message').show().fadeOut(10000);
  #
  #
  #   new_id = json.id
  #   return [success,message,new_id];

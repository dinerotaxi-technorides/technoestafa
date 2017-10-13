function updateJqGrid()
{
        $("#getCorporativeAccount").jqGrid({
            url: host+user_api+'jq_corporative_account?token='+panel.api.token
            , editurl: host+user_api+'jq_user_edit?type=CORPORATEACCOUNT&token='+panel.api.token,
            colNames: [I18n.request.company_name,I18n.request.email,I18n.request.password,I18n.request.phone_number,I18n.request.enabled,I18n.request.id],
            colModel: [{name:'companyName', editable:true},{name:'username', editable:true},
            {name:'password',search:false, edittype:'password',editable:true,editrules:{required:true}, viewable: false},
            {name:'phone', editable:true, editrules:{required:true} ,editoptions: {size:10, manlength: 3}},
            {name:'agree',search:false, editable:true,  editrules:{required:true} ,edittype:'checkbox' },
            {name:'id',hidden:true}],
            sortname: 'firstName', sortorder: "desc",caption: I18n.request.companies,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#getCorporativeAccountPager',datatype: 'json'});

        $('#getCorporativeAccount').navGrid('#getCorporativeAccountPager', {
           add: true,
           edit: true,
           del: false,
           search: true,
           refresh: true
       });

        $(window).resize(function() {
            $('#getCorporativeAccount').fluidGrid({
                  base:'#contactWrapper',
                  offset: -2
            });
        });
        $("#corporativeAccountUsers").jqGrid({url: host+user_api+'jq_corporative_account_users?token='+panel.api.token,
            editurl:  host+user_api+'jq_user_edit?type=CORPORATEACCOUNTUSER&token='+panel.api.token,
            colNames: [I18n.request.company_name,I18n.request.user,I18n.request.password,I18n.request.user_name,I18n.request.user_surname,I18n.request.phone_number,I18n.request.trips,I18n.request.enabled,I18n.request.employee_id,I18n.request.id],
            colModel: [ 
            {name:'empresa',index:'empresa', width:200, sortable:false,
                                             editable:true, edittype:'select'  , editrules:{required:false},
                                     editoptions:{dataUrl:host+user_api+'jq_get_company_account?token='+panel.api.token}
                                            },
            {name:'username', editable:true},
            {name:'password',search:false, edittype:'password',editable:true,editrules:{required:true}, viewable: false},
            {name:'firstName',editable:true,editrules:{required:true}},
            {name:'lastName', editable:true,editrules:{required:true}},
            {name:'phone', editable:true, editrules:{required:true} ,editoptions: {size:10, manlength: 3}},
            {name:'countTripsCompleted',search:false, editable:false},
            {name:'agree',search:false, editable:true,  editrules:{required:true} ,edittype:'checkbox' }, 
            {name:'employeeId',hidden:true},
            {name:'id',hidden:true}],
            sortname: 'firstName', sortorder: "desc",caption: I18n.request.company_employees,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#corporativeAccountUsersPager',datatype: 'json'});
     $('#corporativeAccountUsers').navGrid('#corporativeAccountUsersPager', {
       add: true,
       edit: true,
       del: false,
       search: true,
       refresh: true
    });

     $("#getUsers").jqGrid({url: host+user_api+'jq_users?token='+panel.api.token,
        editurl:  host+user_api+'jq_user_edit?type=USER&token='+panel.api.token,
        colNames: [I18n.request.user,I18n.request.password,I18n.request.user_name,I18n.request.user_surname,I18n.request.phone_number,I18n.request.enabled,I18n.request.id],
        colModel: [ {name:'username', editable:true,searchoptions:{sopt:['cn']}},
        {name:'password',search:false, edittype:'password',editable:true,editrules:{required:true}, viewable: false},
        {name:'firstName',editable:true,editrules:{required:true}},
        {name:'lastName', editable:true,editrules:{required:true}},
        {name:'phone', editable:true, editrules:{required:true} ,editoptions: {size:10, manlength: 3}},
        {name:'agree',search:false, editable:true,  editrules:{required:true} ,edittype:'checkbox' },
        {name:'id',hidden:true}],
        sortname: 'firstName', sortorder: "desc",caption: I18n.request.users,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#getUsersPager',datatype: 'json'});
     $('#getUsers').navGrid('#getUsersPager', {
       add: true,
       edit: true,
       del: false,
       search: true,
       refresh: true
    });

     $("#getEmployUsersOperator").jqGrid({url: host+user_api+'jq_employ_users?typeEmploy=OPERADOR&token='+panel.api.token,
        editurl:  host+user_api+'jq_user_edit?type=EMPLOYUSEROPERATOR&token='+panel.api.token,
        colNames: [I18n.request.user,I18n.request.password,I18n.request.user_name,I18n.request.user_surname,I18n.request.phone_number,I18n.request.operator_telephone,I18n.request.enabled,I18n.request.id],
        colModel: [ {name:'username', editable:true},
        {name:'password',search:false, edittype:'password',editable:true,editrules:{required:true}, viewable: false},
        {name:'firstName',editable:true,editrules:{required:true}},
        {name:'lastName', editable:true,editrules:{required:true}},
        {name:'phone', editable:true, editrules:{required:true} ,editoptions: {size:10, manlength: 3}},
        {name:'typeEmploy',index:'typeEmploy', width:200, sortable:false,
           editable:true, edittype:'select'  , editrules:{required:true},
           editoptions:{dataUrl:host+user_api+'jq_get_type?token='+panel.api.token}
        },
        {name:'agree',search:false, editable:true,  editrules:{required:true} ,edittype:'checkbox' },
        {name:'id',hidden:true}],
        sortname: 'firstName', sortorder: "desc",caption: I18n.request.operators,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#getEmployUsersOperatorPager',datatype: 'json'});
     $('#getEmployUsersOperator').navGrid('#getEmployUsersOperatorPager', {
       add: true,
       edit: true,
       del: false,
       search: false,
       refresh: true
    });
     $("#getVehicleList").jqGrid({url: host+user_api+'jq_vehicule_list?token='+panel.api.token,
        editurl:  host+user_api+'jq_vehicule_edit?token='+panel.api.token,
        colNames:  [I18n.request.car_license,I18n.request.brand,I18n.request.model,I18n.request.active,I18n.request.id],
        colModel: [ {name:'patente', editable:true,editrules:{required:true}},
        {name:'marca', editable:true,editrules:{required:true}},
        {name:'modelo',editable:true,editrules:{required:true}},
        {name:'active',search:false, editable:true,  editrules:{required:true} ,edittype:'checkbox' },
        {name:'id',hidden:true}],
        sortname: 'patente', sortorder: "desc",caption: I18n.request.vehicles,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#getVehicleListPager',datatype: 'json'});
     $('#getVehicleList').navGrid('#getVehicleListPager', {
       add: true,
       edit: true,
       del: false,
       search: true,
       refresh: true
    });
     $("#getOperations").jqGrid({url: host+operation_api+'jq_company_operation_history?token='+panel.api.token,
        editurl:  host+user_api+'jq_vehicule_edit?token='+panel.api.token,
        colNames: [I18n.request.id,I18n.request.date,I18n.request.user_name,I18n.request.user_surname,I18n.request.driver,I18n.request.phone_number,I18n.request.address,I18n.request.comments,I18n.request.status,I18n.request.company_name,I18n.request.id],
        colModel: [ {name:'id',editable:false,editrules:{required:true} },
        {name:'cratedDate',search:false,editable:false,editrules:{required:true} },
        {name:'firstName',search:false,editable:false, editrules:{required:true} },
        {name:'lastName',search:false,editable:false,editrules:{required:true} },                                    
        {name:'auto',search:true, editable:false,editrules:{required:true}},                                
        {name:'phone',search:false, editable:false,editrules:{required:true}},
        {name:'placeFrom',search:false,editable:false,editrules:{required:true}},
        {name:'comments',search:false,editable:false, editrules:{required:true}},     
        {name:'intermidiario',search:false,editable:false,editrules:{required:true}  }, 
        {name:'compania',search:false, editable:false,editrules:{required:true}},
        {name:'id',hidden:true}],
        sortname: 'id', sortorder: "desc",caption: I18n.request.operation_history,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#getOperationsPager',datatype: 'json'});
     $('#getOperations').navGrid('#getOperationsPager', {
       add: false,
       edit: false,
       del: false,
       search: true,
       refresh: true
    });
};

function afterSubmitEvent(response, postdata) {
    var success = true;
    console.log ('here')
    var json = eval('(' + response.responseText + ')');
    var message = json.message;

    if(json.state == 'FAIL') {
        success = false;
    } else {
      $('#message').html(message);
      $('#message').show().fadeOut(10000);  // 10 second fade
    }

    var new_id = json.id
    return [success,message,new_id];
}


    //]]>

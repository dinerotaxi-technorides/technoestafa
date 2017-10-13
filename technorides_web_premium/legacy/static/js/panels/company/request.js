function notAnEmailCheck(value, field) {
  if($("#in_edit").val() == "0")
    return [!(new RegExp(/@/)).test(value), field + ": " + I18n.request.must_not_be_an_email_address];
  else
    return [true, field + ": " + I18n.request.must_not_be_an_email_address];
}

function addExportButton(jqGridId, navGridId) {
  $(jqGridId).navButtonAdd(navGridId, {
    caption      : "",
    buttonicon   : "ui-icon-document",
    onClickButton: function() {
      exportGrid(jqGridId)
    },
    position     : "last",
    title        : window.I18n.request.export,
    cursor: "pointer"
  });
}

function exportGrid(jqGridId) {
  $.ajax({
    url : $(jqGridId).jqGrid("getGridParam", "url"),
    dataType: "json",
    data    : $.extend({},
      $(jqGridId).getGridParam("postData"),
      {
        page: 1,
        rows: 999999999
      }
    )
  }).success(function(data) {
    csv = "data:application/csv;charset=utf-8,";

    csv += $(jqGridId).jqGrid("getGridParam", "colNames").join(",") + "\n";
    rows = data.rows;
    $.each(rows, function(index, value) {
      row = value.cell.join(",");
      csv += index < rows.length ? row + "\n" : row;
    });

    encodedUri = encodeURI(csv);

    defaultExportFilename = $(jqGridId).jqGrid("getGridParam", "defaultExportFilename") || jqGridId.substr(1, jqGridId.length - 1);
    csvName = defaultExportFilename; //prompt(window.I18n.request.choose_a_filename, defaultExportFilename);

    if(csvName != null) {
      var link = document.createElement("a");
      link.setAttribute("href", encodedUri);
      link.setAttribute("download", csvName + ".csv");
      $("body").append(link);
      $(link).hide();
      link.click();
    }
  });
}

function updateJqGrid()
{
        $("#getCorporativeAccount").jqGrid({
            url: host+user_api+'jq_corporative_account?token='+panel.api.token
            , editurl: host+user_api+'jq_user_edit?type=CORPORATEACCOUNT&token='+panel.api.token,
            colNames: [I18n.request.company_name,I18n.request.email,I18n.request.password,I18n.request.phone_number,I18n.request.enabled,I18n.request.id],
            rowNum:13,
            colModel: [{name:'companyName', editable:true},{name:'username', editable:true},
            {name:'password',search:false, edittype:'password',editable:true,editrules:{required:true}, viewable: false, sortable: false, hidden: false},
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
            rowNum:13,
            colModel: [ 
            {name:'empresa',index:'empresa', width:200, sortable:false,
                                             editable:true, edittype:'select'  , editrules:{required:false},
                                     editoptions:{dataUrl:host+user_api+'jq_get_company_account?token='+panel.api.token}
                                            },
            {name:'username', editable:true},
            {name:'password',search:false, edittype:'password',editable:true,editrules:{required:true}, viewable: false, sortable: false, hidden: false},
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

     $("#getUsers").jqGrid({defaultExportFilename: "users", url: host+user_api+'jq_users?token='+panel.api.token,
        editurl:  host+user_api+'jq_user_edit?type=USER&token='+panel.api.token,
        colNames: [I18n.request.created_at, I18n.request.email,I18n.request.password,I18n.request.user_name,I18n.request.user_surname,I18n.request.phone_number,I18n.request.enabled],
        rowNum:13,
        colModel: [{name:'created_at', editable:false,search: false, sortable: false},
        {name:'username', editable:true,searchoptions:{sopt:['cn']}, editrules: {email: true, required: true}},
        {name:'password',search:false, edittype:'password',editable:true,editrules:{required:true}, viewable: false, sortable: false, hidden: false},
        {name:'firstName',editable:true,editrules:{required:true}},
        {name:'lastName', editable:true,editrules:{required:true}},
        {name:'phone', editable:true, editrules:{required:true} ,editoptions: {size:10, manlength: 3}},
        {name:'agree',search:false, editable:true,  editrules:{required:true} ,edittype:'checkbox' }],
        sortname: 'firstName', sortorder: "desc",caption: I18n.request.users,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#getUsersPager',datatype: 'json'});
     $('#getUsers').navGrid('#getUsersPager', {
       add: true,
       edit: true,
       del: false,
       search: true,
       refresh: true
    });

   addExportButton("#getUsers", "#getUsersPager");

     $("#getSectors").jqGrid({url: host+user_api+'jq_users?token='+panel.api.token,
        editurl:  host+user_api+'jq_user_edit?type=USER&token='+panel.api.token,
        colNames: [I18n.request.user,I18n.request.password,I18n.request.user_name,I18n.request.user_surname,I18n.request.phone_number,I18n.request.enabled,I18n.request.id],
        rowNum:13,
        colModel: [ {name:'username', editable:true,searchoptions:{sopt:['cn']}},
        {name:'password',search:false, edittype:'password',editable:true,editrules:{required:true}, viewable: false, sortable: false, hidden: false},
        {name:'firstName',editable:true,editrules:{required:true}},
        {name:'lastName', editable:true,editrules:{required:true}},
        {name:'phone', editable:true, editrules:{required:true} ,editoptions: {size:10, manlength: 3}},
        {name:'agree',search:false, editable:true,  editrules:{required:true} ,edittype:'checkbox' },
        {name:'id',hidden:true}],
        sortname: 'firstName', sortorder: "desc",caption: I18n.request.sectors,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#getSectorsPager',datatype: 'json'});
     $('#getSectors').navGrid('#getSectorsPager', {
       add: true,
       edit: true,
       del: false,
       search: true,
       refresh: true
    });

     $("#getEmployUsersOperator").jqGrid({url: host+user_api+'jq_employ_users?typeEmploy=OPERADOR&token='+panel.api.token,
        editurl:  host+user_api+'jq_user_edit?type=EMPLOYUSEROPERATOR&token='+panel.api.token,
        colNames: [I18n.request.user, I18n.request.password, I18n.request.user_name, I18n.request.user_surname, I18n.request.phone_number, I18n.request.operator_telephone, I18n.request.enabled,I18n.request.id],
        rowNum:13,
        colModel: [ {name:'username', editable:true, editrules: {required: true, custom: true, custom_func: notAnEmailCheck}},
        {name:'password',search:false, edittype:'password',editable:true,editrules:{required:true}, viewable: false, sortable: false, hidden: false},
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
       del: true,
       search: false,
       refresh: true
    });

     $("#getVehicleList").jqGrid({url: host+user_api+'jq_vehicule_list?token='+panel.api.token,
        editurl:  host+user_api+'jq_vehicule_edit?token='+panel.api.token,
        colNames:  [I18n.request.car_license,I18n.request.brand,I18n.request.model,I18n.request.active,I18n.request.id],
        rowNum:13,
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
     $("#getOperations").jqGrid({defaultExportFilename: "history", url: host+operation_api+'jq_company_operation_history?token='+panel.api.token,
        editurl:  host+user_api+'jq_vehicule_edit?token='+panel.api.token,
        colNames: [
          I18n.request.id,
          I18n.request.date,
          I18n.request.user_name,
          I18n.request.user_surname,
          I18n.request.driver,
          I18n.request.phone_number,
          I18n.request.address,
          I18n.request.address_to,
          I18n.request.comments,
          I18n.request.stars,
          I18n.request.status,
          I18n.request.amount
        ],
        rowNum:13,
        colModel: [
          {name: 'id',editable:false,editrules:{required:true}},
          {name: 'cratedDate',search:false,editable:false,editrules:{required:true}, sortable: false},
          {name: 'firstName',search:false,editable:false, editrules:{required:true}, sortable: false},
          {name: 'lastName',search:false,editable:false,editrules:{required:true}, sortable: false},
          {name: 'auto',search:true, editable:false,editrules:{required:true}},
          {name: 'phone',search:false, editable:false,editrules:{required:true}, sortable: false},
          {name: 'placeFrom',search:false,editable:false,editrules:{required:true}, sortable: false},
          {name: 'placeTo',search:false,editable:false,editrules:{required:true}, sortable: false},
          {name: 'comments',search:false,editable:false, editrules:{required:true}, sortable: false},
          {name: 'stars',search:false,editable:false},
          {name: 'status',search:false, editable:false},
          {name: 'amount',search:false, editable:false}
        ],
        sortname: 'id', sortorder: "desc",caption: I18n.request.operation_history,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#getOperationsPager',datatype: 'json'});
     $('#getOperations').navGrid('#getOperationsPager', {
       add: false,
       edit: false,
       del: false,
       search: true,
       refresh: true
    });
   addExportButton("#getOperations", "#getOperationsPager");

     $("#getZones").jqGrid({
        url: host + "technoRidesZoneApi/jq_zone_pricing?token=" + panel.api.token,
        editurl:  host + "technoRidesZoneApi/jq_edit_zone_pricing?token=" + panel.api.token,
        colNames: [
          "id",
          "date",
          I18n.request.amount,
          I18n.request.zone_from,
          I18n.request.zone_to
        ],
        rowNum:13,
        colModel: [
          {name:'id', editable: false, viewable: false, hidden: true},
          {name:'date', editable: false, viewable: false, hidden: true},
          {name:'amount', editable: true, editrules: {required: true}},
          {name:'zoneFrom',search: false, editable: false, viewable: false},
          {name:'zoneTo',search: false, editable: false, viewable: false}
        ],
        sortname: 'zoneFrom', sortorder: "desc",caption: I18n.request.zones,height: 300,autowidth: true,scrollOffset: 0,viewrecords: true,pager: '#getZonesPager',datatype: 'json'
     });

     $('#getZones').navGrid('#getZonesPager', {
       add: false,
       edit: true,
       del: false,
       search: false,
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

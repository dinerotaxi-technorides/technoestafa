<%@ page import="ar.com.goliath.TypeEmployer"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns:og="http://ogp.me/ns#">
<head>
<meta name="layout" content="dineroTaxiAdminL" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- META for Google Webmasters -->
<meta name="google-site-verification"
    content="NBzIvboQVvrq0MoRtNg_bbN7g6Qf-zWkn6wDGarb0lk" />
<meta name="author" content="DineroTaxi" />
<meta name="version" content="1.0" />
<meta name="description"
    content="DineroTaxi es un servicio para pedir taxis de forma automatica desde el movil. Con DineroTaxi tienes tu taxi en tu movil">
<meta name="keywords"
    content="taxi quiero pedir solicitar Madrid Barcelona Sevilla Valencia automatico aqui ahora android iphone blackberry">
<meta name="copyright"
    content="Copyright (c) DineroTaxi.com Todos los derechos reservados." />
<!-- METAS for Facebook -->
<meta property="og:title" content="DineroTaxi" />
<meta property="og:type" content="company" />
<meta property="og:url" content="https://www.dinerotaxi.com" />
<meta property="og:image"
    content="${resource(dir:'img',file:'favicon.ico')}" />
<link rel="shortcut icon"
    href="${resource(dir:'img',file:'favicon.ico')}" type="image/x-icon" />
<link rel="apple-touch-icon-precomposed"
    href="${resource(dir:'images',file:'favicon.ico')}">

<%--    --%>
<%--    <link rel="stylesheet" href="${resource(dir:'css/dinerotaxi',file:'modal.css')}" />--%>
<%--    <link rel="stylesheet" href="${resource(dir:'css',file:'jquery-ui.tbo.css')}" />--%>
<%--   --%>


<!--Google Analytics-->
<title>Dinero Taxi.com La nueva Forma de pedir un taxi</title>

<!-- This JavaScript snippet activates those tabs -->

<jqui:resources />
<jqgrid:resources />
<script type="text/javascript">
            $(document).ready(function() {
                  <jqgrid:grid
                  id="Billing"
                      url="'${createLink(action:'jq_billing_list',controller:'incomeAndExcome')}'"
                          editurl="'${createLink(action:'jq_edit_billing',controller:'incomeAndExcome')}'"
                  colNames="'billingDate','companyName','recive','comments','amount','hadpaid','id'"
                     colModel="{name:'billingDate',editable:true,editrules:{required:true}},
                                {name:'companyName', editable:false,editrules:{required:false}},
                                {name:'recive', editable:true,editrules:{required:false}},
                                {name:'comments', editable:true,editrules:{required:false}},
                                {name:'amount', editable:true,editrules:{required:true}},
                                {name:'hadpaid', editable:true,  editrules:{required:true} ,edittype:'checkbox' },
                                {name:'id',hidden:true}"
                  sortname="'billingDate'"
                  caption="'Billing'"
                  height="300"
                  autowidth="true"
                  scrollOffset="0"
                  viewrecords="true"
                  showPager="true"
                  datatype="'json'">
                  <jqgrid:navigation id="Billing" add="false" edit="true"  search="true" refresh="true" />
                  <jqgrid:resize id="Billing" resizeOffset="-2" />
           </jqgrid:grid>    
           <jqgrid:grid
           id="expenses"
               url="'${createLink(action:'jq_expenses_list',controller:'incomeAndExcome')}'"
                   editurl="'${createLink(action:'jq_edit_excome',controller:'incomeAndExcome')}'"
           colNames="'createdDate','receiptNumber','Supplier','concept','CUIT','base ','tax ','base 21%','tax 21','base 10.5','tax 10.5','base 27 ','tax 27','MONOTYCF','NOGRAV','PERS.iva','IIBBCF','comments','total','typeCredit','currency ','typeTax','company','id'"
             colModel="{name:'createdDate', editable:true,editrules:{required:true}},
                        {name:'receiptNumber', editable:true,editrules:{required:true}},
                        {name:'supplier',editable:true,editrules:{required:true}},
                            {name:'concept', editable:true, editrules:{required:true}},
                            {name:'typeCuit', editable:true, editrules:{required:true}},
                            {name:'base', editable:true,editrules:{required:true}},
                            {name:'tax', editable:true,editrules:{required:false}},
                            {name:'base1', editable:true,editrules:{required:false}},
                            {name:'tax1', editable:true,editrules:{required:false}},
                            {name:'base2', editable:true,editrules:{required:false}},
                            {name:'tax2', editable:true,editrules:{required:false}},
                            {name:'base3', editable:true,editrules:{required:false}},
                            {name:'tax3', editable:true,editrules:{required:false}},
                            {name:'base8', editable:true,editrules:{required:false}},
                            {name:'base9', editable:true,editrules:{required:false}},
                            {name:'base10', editable:true,editrules:{required:false}},
                            {name:'base11', editable:true,editrules:{required:false}},
                            {name:'comments', editable:true,editrules:{required:false}},
                            {name:'total', editable:true,editrules:{required:true}},
                            
                            {name:'typeCredit', width:200, sortable:true,
                                 editable:true, edittype:'select'  , editrules:{required:true},
                                 editoptions:{dataUrl:'${createLink(action:'jq_get_expenses_type_credit',controller:'incomeAndExcome')}'}
                            },
                            {name:'currency', width:200, sortable:true,
                             editable:true, edittype:'select'  , editrules:{required:true},
                             editoptions:{dataUrl:'${createLink(action:'jq_get_expenses_currency',controller:'incomeAndExcome')}'}
                            },
                            {name:'typeTax', width:200, sortable:true,
                             editable:true, edittype:'select'  , editrules:{required:true},
                             editoptions:{dataUrl:'${createLink(action:'jq_get_expenses_type_tax',controller:'incomeAndExcome')}'}
                            },
                            {name:'company', width:200, sortable:true,
                             editable:true, edittype:'select'  , editrules:{required:false},
                             editoptions:{dataUrl:'${createLink(action:'jq_get_expenses_company',controller:'incomeAndExcome')}'}
                            },
                            
                           {name:'id',hidden:true}"
           sortname="'createdDate'"
           caption="'Expenses'"
           height="300"
           autowidth="true"
           scrollOffset="0"
           viewrecords="true"
           showPager="true"
           datatype="'json'">
           <jqgrid:navigation id="expenses" add="true" edit="true"  search="true" refresh="true" del="true" />
           <jqgrid:resize id="expenses" resizeOffset="-2" />
         </jqgrid:grid>
         <jqgrid:grid
         id="expenses_credit"
             url="'${createLink(action:'jq_expenses_credit_card_list',controller:'incomeAndExcome')}'"
                 editurl="'${createLink(action:'jq_edit_excome',controller:'incomeAndExcome')}'"
         colNames="'createdDate','receiptNumber','Supplier','concept','CUIT','base ','exchange','dbrg 35%','creditCardNumber','comments','total','typeCredit','currency ','typeTax','company','id'"
              colModel="{name:'createdDate', editable:true,editrules:{required:true}},
           {name:'receiptNumber', editable:true,editrules:{required:true}},
           {name:'supplier',editable:true,editrules:{required:true}},
               {name:'concept', editable:true, editrules:{required:true}},
               {name:'typeCuit', editable:true, editrules:{required:true}},
               {name:'base', editable:true,editrules:{required:true}},
               {name:'exchanges', editable:true,editrules:{required:false}},
               {name:'base1', editable:true,editrules:{required:false}},
               {name:'creditCardNumber', editable:true,editrules:{required:false}},
               {name:'comments', editable:true,editrules:{required:false}},
               {name:'total', editable:true,editrules:{required:true}},
               {name:'typeCredit', width:200, sortable:true,
                    editable:true, edittype:'select'  , editrules:{required:true},
                    editoptions:{dataUrl:'${createLink(action:'jq_get_expenses_type_credit',controller:'incomeAndExcome')}'}
               },
               {name:'currency', width:200, sortable:true,
                editable:true, edittype:'select'  , editrules:{required:true},
                editoptions:{dataUrl:'${createLink(action:'jq_get_expenses_currency',controller:'incomeAndExcome')}'}
               },
               {name:'typeTax', width:200, sortable:true,
                editable:true, edittype:'select'  , editrules:{required:true},
                editoptions:{dataUrl:'${createLink(action:'jq_get_expenses_type_tax',controller:'incomeAndExcome')}'}
               },
               {name:'company', width:200, sortable:true,
                editable:true, edittype:'select'  , editrules:{required:false},
                editoptions:{dataUrl:'${createLink(action:'jq_get_expenses_company',controller:'incomeAndExcome')}'}
               },
                          
                         {name:'id',hidden:true}"
         sortname="'createdDate'"
         caption="'Expenses'"
         height="300"
         autowidth="true"
         scrollOffset="0"
         viewrecords="true"
         showPager="true"
         datatype="'json'">
         <jqgrid:navigation id="expenses_credit" add="true" edit="true"  search="true" refresh="true" del="true" />
         <jqgrid:resize id="expenses_credit" resizeOffset="-2" />
       </jqgrid:grid>
      
                 
               });
            function isAlphabet(value, colname) {
                var alphaExp = /^[0-9a-zA-Z]+$/;
                if(value.match(alphaExp)){
                       return [true,""];
                }else{
                       return [false,"Solo se puede escribir Letras o numeros en la columna "+colname];
                }
            }
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
         
                        
        </script>
</head>
<body>


    <div class="mainContent_">


        <div class="con">

            <g:render template="/tripPanelAdmin/sidebar"
                model="['action':'audit']" />
            <!-- DETAIL -->



            <div class="boxPanelTaxista">



                <h1>Usuarios</h1>

                <div id='message' class="message" style="display: none;"></div>


                <div class="clearFix">
                    <br />
                </div>
                <jqgrid:wrapper id="Billing" />
                <div class="clearFix">
                    <br />
                </div>
                <jqgrid:wrapper id="expenses" />
                <div class="clearFix">
                    <br />
                </div>
                <jqgrid:wrapper id="expenses_credit" />


            </div>


        </div>

    </div>
    <!-- END MAIN -->
</body>
</html>

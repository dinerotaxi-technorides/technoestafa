 $('#${attrs.id}Grid').navGrid('#${attrs.id}GridPager',{
   add: ${attrs.add ?: false},
   edit: ${attrs.edit ?: false},
   del: ${attrs.del ?: false},
   search: ${attrs.search ?: false},
   refresh: ${attrs.refresh ?: false}},     
                    {closeAfterEdit:true,
                     afterSubmit:afterSubmitEvent
                    },                                   // edit options
                    {addCaption:'Create New Customer',
                     afterSubmit:afterSubmitEvent,
                     savekey:[true,13]},            // add options
                    {caption:'${attrs.delcapt ?: 'Borrar Registros'}',msg:'${attrs.delcaptmsg ?: 'Seguro desea elimiar el registro?'}', afterSubmit:afterSubmitEvent }  // delete options
      , {multipleSearch:true, multipleGroup:false, showQuery: false}              
);


package com.admin

class SuppliersCommand {
   
                String address1
                String address2
                String city
                String companyName
                String contactName
                String contactTitle
                String country
                String currentOrder
                String email
                String fax
                String firstContact
                String notes
                String paymentMethods
                String phone
                String state
    String offset
    String max
    String validateAllParams(Object params){
         String val=""
        /* if(params?.fechAfecd || params?.fechAfech){
            if(!params?.fechAfecd || !params?.fechAfech){
                val=val+"Para filtrar por fecha de afectación debe ingresar desde y hasta /"
            }
         }
         if(params?.fecDesafd || params?.fecDesafh ){
            if(!params?.fecDesafd || !params?.fecDesafh ){
                val=val+"Para filtrar por fecha de desafectación debe ingresar desde y hasta"
            }
         }*/
        return val
     }

     void commandSetParameters(Object params){
            offset=params?.offset?params.offset:"0"
            max=params?.max?params.max:"5"
               
                address1=params?.address1?params.address1:null
                address2=params?.address2?params.address2:null
                city=params?.city?params.city:null
                companyName=params?.companyName?params.companyName:null
                contactName=params?.contactName?params.contactName:null
                contactTitle=params?.contactTitle?params.contactTitle:null
                country=params?.country?params.country:null
                currentOrder=params?.currentOrder?params.currentOrder:null
                email=params?.email?params.email:null
                fax=params?.fax?params.fax:null
                firstContact=params?.firstContact?params.firstContact:null
                notes=params?.notes?params.notes:null
                paymentMethods=params?.paymentMethods?params.paymentMethods:null
                phone=params?.phone?params.phone:null
                state=params?.state?params.state:null

     }
}


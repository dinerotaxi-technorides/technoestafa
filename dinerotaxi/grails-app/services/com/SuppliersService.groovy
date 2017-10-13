package com

import com.admin.SuppliersCommand;


class SuppliersService {

    boolean transactional = true
    def getAll( params) {
        def c = Suppliers.createCriteria()
        def results = c.list([offset:params.offset,max:params.max]) {
            and{
           
                        if(params.address1!=null){
                            like('address1', params.address1)
                        }
                    
                        if(params.address2!=null){
                            like('address2', params.address2)
                        }
                    
                        if(params.city!=null){
                            like('city', params.city)
                        }
                    
                        if(params.companyName!=null){
                            like('companyName', params.companyName)
                        }
                    
                        if(params.contactName!=null){
                            like('contactName', params.contactName)
                        }
                    
                        if(params.contactTitle!=null){
                            like('contactTitle', params.contactTitle)
                        }
                    
                        if(params.country!=null){
                            like('country', params.country)
                        }
                    
                        if(params.currentOrder!=null){
                            like('currentOrder', params.currentOrder)
                        }
                    
                        if(params.email!=null){
                            like('email', params.email)
                        }
                    
                        if(params.fax!=null){
                            like('fax', params.fax)
                        }
                    
                        if(params.firstContact!=null){
                            like('firstContact', params.firstContact)
                        }
                    
                        if(params.notes!=null){
                            like('notes', params.notes)
                        }
                    
                        if(params.paymentMethods!=null){
                            like('paymentMethods', params.paymentMethods)
                        }
                    
                        if(params.phone!=null){
                            like('phone', params.phone)
                        }
                    
                        if(params.state!=null){
                            like('state', params.state)
                        }
                    
            }
        }

        return results
    }
    def getAllCount( params) {
        def c = Suppliers.createCriteria()
         def results = c.get() {
           
                        if(params.address1!=null){
                            like('address1', params.address1)
                        }
                    
                        if(params.address2!=null){
                            like('address2', params.address2)
                        }
                    
                        if(params.city!=null){
                            like('city', params.city)
                        }
                    
                        if(params.companyName!=null){
                            like('companyName', params.companyName)
                        }
                    
                        if(params.contactName!=null){
                            like('contactName', params.contactName)
                        }
                    
                        if(params.contactTitle!=null){
                            like('contactTitle', params.contactTitle)
                        }
                    
                        if(params.country!=null){
                            like('country', params.country)
                        }
                    
                        if(params.currentOrder!=null){
                            like('currentOrder', params.currentOrder)
                        }
                    
                        if(params.email!=null){
                            like('email', params.email)
                        }
                    
                        if(params.fax!=null){
                            like('fax', params.fax)
                        }
                    
                        if(params.firstContact!=null){
                            like('firstContact', params.firstContact)
                        }
                    
                        if(params.notes!=null){
                            like('notes', params.notes)
                        }
                    
                        if(params.paymentMethods!=null){
                            like('paymentMethods', params.paymentMethods)
                        }
                    
                        if(params.phone!=null){
                            like('phone', params.phone)
                        }
                    
                        if(params.state!=null){
                            like('state', params.state)
                        }
                    
            projections{
                count("id")
            }
        }
        return results
    }
}
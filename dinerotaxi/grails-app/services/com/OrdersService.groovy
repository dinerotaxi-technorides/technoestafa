package com

import com.admin.OrdersCommand;


class OrdersService {

    boolean transactional = true
    def getAll( params) {
        def c = Orders.createCriteria()
        def results = c.list([offset:params.offset,max:params.max]) {
            and{
           
                        if(params.errLoc!=null){
                            like('errLoc', params.errLoc)
                        }
                    
                        if(params.errMsg!=null){
                            like('errMsg', params.errMsg)
                        }
                    eq('deleted',false)
            }
        }

        return results
    }
    def getAllCount( params) {
        def c = Orders.createCriteria()
         def results = c.get() {
           
                        if(params.errLoc!=null){
                            like('errLoc', params.errLoc)
                        }
                    
                        if(params.errMsg!=null){
                            like('errMsg', params.errMsg)
                        }
						eq('deleted',false)
                    
            projections{
                count("id")
            }
        }
        return results
    }
}
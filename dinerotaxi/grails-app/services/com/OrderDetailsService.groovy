package com

import com.admin.OrderDetailsCommand;


class OrderDetailsService {

    boolean transactional = true
    def getAll( params) {
        def c = OrderDetails.createCriteria()
        def results = c.list([offset:params.offset,max:params.max]) {
            and{
           
            }
        }

        return results
    }
    def getAllCount( params) {
        def c = OrderDetails.createCriteria()
         def results = c.get() {
           
            projections{
                count("id")
            }
        }
        return results
    }
}
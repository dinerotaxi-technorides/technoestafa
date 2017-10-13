package com

import com.admin.ProductCommand;


class ProductService {

    boolean transactional = true
    def getAll( params) {
        def c = Product.createCriteria()
        def results = c.list([offset:params.offset,max:params.max]) {
            and{
           
                        if(params.name!=null){
                            like('name', params.name)
                        }
                    
                        if(params.description!=null){
                            like('description', params.description)
                        }
                    
                        if(params.note!=null){
                            like('note', params.note)
                        }
                    
            }
        }

        return results
    }
    def getAllCount( params) {
        def c = Product.createCriteria()
         def results = c.get() {
           
                        if(params.name!=null){
                            like('name', params.name)
                        }
                     
                        if(params.description!=null){
                            like('description', params.description)
                        }
                    
                        if(params.note!=null){
                            like('note', params.note)
                        }
                    
            projections{
                count("id")
            }
        }
        return results
    }
}
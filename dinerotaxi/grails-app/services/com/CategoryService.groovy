package com

import com.admin.CategoryCommand;


class CategoryService {

    boolean transactional = true
    def getAll( params) {
        def c = Category.createCriteria()
        def results = c.list([offset:params.offset,max:params.max]) {
            and{
           
                        if(params.name!=null){
                            like('name', params.name)
                        }
                    
                        if(params.description!=null){
                            like('description', params.description)
                        }
                    
            }
        }

        return results
    }
    def getAllCount( params) {
        def c = Category.createCriteria()
         def results = c.get() {
                if(params.name!=null){
                    like('name', params.name)
                }
            
                if(params.description!=null){
                    like('description', params.description)
                }
                    
            projections{
                count("id")
            }
        }
        return results
    }
}
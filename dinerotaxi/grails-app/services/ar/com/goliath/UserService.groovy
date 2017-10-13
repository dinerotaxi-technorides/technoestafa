package ar.com.goliath


class UserService {

    boolean transactional = true
    def getAll(UserCommand params) {
        def c = User.createCriteria()
        def results = c.list([offset:params.offset,max:params.max]) {
            and{
           
                        if(params.username!=null){
                            like('username', params.username)
                        }
                    
                        if(params.password!=null){
                            like('password', params.password)
                        }
                    
                        if(params.email!=null){
                            like('email', params.email)
                        }
                    
                        if(params.firstName!=null){
                            like('firstName', params.firstName)
                        }
                    
                        if(params.lastName!=null){
                            like('lastName', params.lastName)
                        }
                    
            }
        }

        return results
    }
    def getAllCount(UserCommand params) {
        def c = User.createCriteria()
         def results = c.get() {
           
                        if(params.username!=null){
                            like('username', params.username)
                        }
                    
                        if(params.password!=null){
                            like('password', params.password)
                        }
                    
                        if(params.email!=null){
                            like('email', params.email)
                        }
                    
                        if(params.firstName!=null){
                            like('firstName', params.firstName)
                        }
                    
                        if(params.lastName!=null){
                            like('lastName', params.lastName)
                        }
                    
            projections{
                count("id")
            }
        }
        return results
    }
}
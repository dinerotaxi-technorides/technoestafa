package ar.com.goliath


class RoleService {

    boolean transactional = true
    def getAll(RoleCommand params) {
        def c = Role.createCriteria()
        def results = c.list([offset:params.offset,max:params.max]) {
            and{

                        if(params.authority!=null){
                            like('authority', params.authority)
                        }

            }
        }

        return results
    }
    def getAllCount(RoleCommand params) {
        def c = Role.createCriteria()
         def results = c.get() {

                        if(params.authority!=null){
                            like('authority', params.authority)
                        }

            projections{
                count("id")
            }
        }
        return results
    }
	def cleanUrlsForRole(roleSelected){
		Requestmap.list().each{requestj->
			def attributes=[]
			requestj.configAttribute.split(",").collect{
				if(!roleSelected.authority.toString().trim().equals(it.toString().trim()) && !it.toString().trim().equals("null")){
					attributes.add(it)
				}

			}
			if(attributes.isEmpty()){
				requestj.delete(flush:true)
			}else{
				requestj.configAttribute= attributes=!null? attributes.join(","):"IS_AUTHENTICATED_ANONYMOUSLY"
				if(!requestj.save(flush:true)){
					requestj.errors.each{
						log.error it
					}
				}
			}

		}
	}
	def roleUpdater(roleSelected,urls,country){

		urls.each{
			if(it!=null){
				def url=country+it
				def requestToAdd=Requestmap.findByUrl(url.toString())
				if(requestToAdd){
					if(requestToAdd.configAttribute==null || requestToAdd.configAttribute.equals("")){
						requestToAdd.configAttribute=roleSelected.authority.toString().trim()
						requestToAdd.save(flush:true)
					}else{
						requestToAdd.configAttribute+=","+roleSelected.authority.toString().trim()
						requestToAdd.save(flush:true)
					}
				}else{
					def reqeustNew=new Requestmap(configAttribute:roleSelected.authority.toString().trim(),url:url).save(flush:true)
				}
			}
		}
	}
}

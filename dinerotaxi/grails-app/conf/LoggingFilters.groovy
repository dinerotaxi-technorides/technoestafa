import ar.com.goliath.*

class LoggingFilters {
	def springSecurityService
	def filters = {
		loginCheck(controller: '*', action: '*') {
			before = {
				try{
//					def parametros= params as grails.converters.JSON
//					User user = springSecurityService.currentUser
//					if(user?.username){
//						def auditoria=new Audit (ip:request.getRemoteAddr()?:"not found",page:request.getRequestURL(),jsonParams:parametros.toString(),email:user.username)
//						if(!auditoria.save(flush:true,failOnError:true)){
//						}else{
//						}
//					}else{
//						def auditoria=new Audit (ip:request.getRemoteAddr()?:"not found",page:request.getRequestURL(),jsonParams:parametros.toString(),email:'     ')
//						if(!auditoria.save(flush:true,failOnError:true)){
//						}else{
//						}
//					}
					
					
				}catch (Exception e){
					log.error e.getMessage()
				}
						
			}
		}
	}
}


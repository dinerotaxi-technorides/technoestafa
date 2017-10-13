
class WebsiteController {

    static defaultAction = 'index'


	def beforeInterceptor = {
        log.info "START ${actionUri} with params=${params}"
    }
	def afterInterceptor = {
        log.info "END ${actionUri}"
    }

	def index() {
		def user
		List userFriends = []
        
	}

	def logout() {
		redirect action: 'index'
	}

	def welcome() {}

}

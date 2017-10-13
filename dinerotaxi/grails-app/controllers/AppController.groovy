
import ar.com.goliath.*
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.core.Authentication
import ar.com.goliath.PersistToken
class AppController {

  static defaultAction = 'index'
	def springSecurityService
	def springDineroTaxiService
	def rememberMeServices

  def beforeInterceptor = {
      log.info "START ${actionUri} with params=${params}"
  }
  def afterInterceptor = {
      log.info "END ${actionUri}"
  }

}

package com


/**
 *
 * @author Igor Artamonov (http://igorartamonov.com)
 * @since 04.11.11
 */
class FacebookAuthCookieLogoutHandler {
	//implements LogoutHandler {

	//    private static final Logger logger = Logger.getLogger(this)
	//
	//    FacebookAuthUtils facebookAuthUtils
	//
	//    void logout(HttpServletRequest httpServletRequest,
	//                HttpServletResponse httpServletResponse,
	//                Authentication authentication) {
	//
	//      String baseDomain = null
	//
	//      List<Cookie> cookies = httpServletRequest.cookies.findAll { Cookie it ->
	//          //FacebookAuthUtils.log.debug("Cookier $it.name, expected $cookieName")
	//          return it.name ==~ /fb\w*_$facebookAuthUtils.applicationId/
	//      }
	//
	//      baseDomain = cookies.find {
	//        return it.name == "fbm_\$facebookAuthUtils.applicationId" && it.value ==~ /base_domain=.+/
	//      }?.value?.split('=')?.last()
	//
	//      if (!baseDomain) {
	//        //Facebook uses invalid cookie format, so sometimes we need to parse it manually
	//        String rawCookie = httpServletRequest.getHeader('Cookie')
	//        if (rawCookie) {
	//          Matcher m = rawCookie =~ /fbm_$facebookAuthUtils.applicationId=base_domain=(.+?);/
	//          if (m.find()) {
	//            baseDomain = m.group(1)
	//          }
	//        }
	//      }
	//
	//      if (!baseDomain) {
	//        logger.warn("Can't find base domain for Facebook cookie. Running on localhost?")
	//      }
	//
	//      cookies.each { cookie ->
	//        cookie.maxAge = 0
	//        cookie.path = '/'
	//        if (baseDomain) {
	//          cookie.domain = baseDomain
	//        }
	//        httpServletResponse.addCookie(cookie)
	//      }
	//    }
}




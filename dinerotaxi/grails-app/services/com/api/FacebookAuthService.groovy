package com.api
import ar.com.goliath.*
/**
 * 
 * @author Igor Artamonov (http://igorartamonov.com)
 * @since 15.01.12
 */
class FacebookAuthService {

	//    void onCreate(FacebookUser user, FacebookAuthToken token) {
	//        log.info("Creating user: $user for fb user: $token.uid")
	//    }
	//
	//    void afterCreate(FacebookUser user, FacebookAuthToken token) {
	//        log.info("User created: $user for fb user: $token.uid")
	//    }
	//
	//    // ********************************************************************************************
	//    //
	//    // You can remove X_ prefix from following methods, if you need some logic specific for your app
	//    //
	//    // ********************************************************************************************
	//
	//    /**
	//     * !!! remove X_ to use this method
	//     *
	//     * Called when facebook user is authenticated (on every request), must return existing
	//     * instance for specified facebook uid, if exits. If doesn't - return null
	//     *
	//     * @param uid facebook user id
	//     */
	//    FacebookUser findUser(Long uid) {
	//        log.info("Search for facebook user with id $uid")
	//        return FacebookUser.findByUid(uid)
	//    }
	//
	//    /**
	//     * !!! remove X_ to use this method
	//     *
	//     * Called when we have a new facebook user, called on first login to create all required
	//     * data structures
	//     *
	//     * @param token facebook authentication token
	//     */
	//    FacebookUser create(FacebookAuthToken token) {
	//        log.info("Create domain for facebook user $token.uid")
	//		log.info token.accessToken.accessToken
	//		String tkn=token.accessToken.accessToken
	//		Facebook facebook = new FacebookTemplate(tkn)
	//		FacebookProfile fbProfile = facebook.userOperations().getUserProfile()
	//		log.info fbProfile.getEmail()
	//		String email = fbProfile.getEmail()
	//		String firstName=fbProfile.getFirstName()!=null?fbProfile.getFirstName():token.uid
	//		String lastName=fbProfile.getLastName()!=null?fbProfile.getLastName() :token.uid
	//        def person = RealUser.findByUsername(email)?:new RealUser(
	//                username: email,
	//                email: email,
	//                password: '$token.uid',
	//                enabled: true,
	//                accountExpired:  false,
	//				status:UStatus.DONE,
	//                accountLocked: false,
	//                passwordExpired: false,
	//                politics: true,
	//                agree: true,
	//				firstName: firstName,
	//				lastName:lastName,
	//				phone:"123123"
	//
	//        ).save(flush:true)
	//		person.errors.each {
	//        	log.debug( it)
	//		}
	//
	//		def userRole=Role.findByAuthority("ROLE_USER")?:new Role(authority:"ROLE_USER").save(flush:true)
	//		def userRole1=Role.findByAuthority("ROLE_FACEBOOK")?:new Role(authority:"ROLE_FACEBOOK").save(flush:true)
	//        UserRole.create(person, userRole)
	//        UserRole.create(person, userRole1)
	//        FacebookUser fbUser = new FacebookUser(
	//                uid: token.uid,
	//                accessToken: tkn,
	//                user: person
	//        )
	//        fbUser.save(flush:true)
	//		fbUser.errors.each {
	//        	log.debug( it)
	//		}
	//        return fbUser
	//    }
	//
	//    /**
	//     * !!! remove X_ to use this method
	//     *
	//     * Called when we have a new facebook user, called on first login to create main app User domain (when
	//     * we store Facebook User details in different domain)
	//     *
	//     * @param token facebook authentication token
	//     */
	//    User  createAppUser(FacebookUser user, FacebookAuthToken token) {
	//        log.info("Create app user for facebook user $token.uid")
	//		Facebook facebook = new FacebookTemplate(token.accessToken)
	//		FacebookProfile fbProfile = facebook.userOperations().userProfile
	//		String email = fbProfile.getEmail()
	//		String firstName=fbProfile.getFirstName()!=null?fbProfile.getFirstName():token.uid
	//		String lastName=fbProfile.getLastName()!=null?fbProfile.getLastName() :token.uid
	//        def person = RealUser.findByUsername(email)?:new RealUser(
	//                username: email,
	//                email: email,
	//                password: '$token.uid',
	//                enabled: true,
	//                accountExpired:  false,
	//				status:UStatus.DONE,
	//                accountLocked: false,
	//                passwordExpired: false,
	//                politics: true,
	//                agree: true,
	//				firstName: firstName,
	//				lastName:lastName,
	//				phone:"123123"
	//        ).save(failOnError:true)
	//        return person
	//    }
	//
	//    /**
	//     * !!! remove X_ to use this method
	//     *
	//     * Called when we have a new facebook user, called on first login to create roles list for new user
	//     *
	//     * @param user facebook user
	//     */
	//    void  createRoles(FacebookUser user) {
	//        log.info("Create role for facebook user $user.uid")
	//        UserRole.create(user.user, Role.findByAuthority('ROLE_USER'))
	//        UserRole.create(user.user, Role.findByAuthority('ROLE_FACEBOOK'))
	//    }
	//
	//    /**
	//     * !!! remove X_ to use this method
	//     *
	//     * Must returns object to store in security context for specified facebook user (can return itself)
	//     *
	//     * @param user facebook user
	//     */
	//    def getPrincipal(FacebookUser user) {
	//        log.info("Ger principal for facebook user #$user.id")
	////		user.refresh()
	//		user.attach()
	//
	//        return user.user
	//    }
	//
	//    /**
	//     * !!! remove X_ to use this method
	//     *
	//     * Must return roles list for specified facebook user
	//     *
	//     * @param user facebook user
	//     */
	//    Collection<GrantedAuthority> getRoles(FacebookUser user) {
	//        log.info("Ger roles for facebook user #$user.id")
	//		if(user?.id){
	//			user.refresh()
	//			def u=RealUser.get(user.user.id)
	//			return u.authorities.collect {
	//				new GrantedAuthorityImpl(it.authority)
	//			}
	//		}else{
	//			return null;
	//		}
	//
	//
	//    }
	//
	//    /**
	//     * !!! remove X_ to use this method
	//     *
	//     * Must return roles list for specified facebook user
	//     *
	//     * @param user facebook user
	//     */
	//    void prepopulateAppUser(User user, FacebookAuthToken token) {
	//        log.info("Prepopulate app user")
	//        user.password = '*******'
	//        user.username = "test_$token.uid"
	//        user.accountExpired = false
	//        user.accountLocked = false
	//        user.enabled = true
	//        user.passwordExpired = false
	//    }

}

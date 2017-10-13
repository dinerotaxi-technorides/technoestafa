package com.api
import ar.com.goliath.*
class FacebookService  {
	//
	//        static transactional = false
	//
	//        /**
	//         * Returns a valid username related to the facebook user details.
	//         *
	//         * @param details the facebook authentication details
	//         * @return the alias associated with the email given
	//         */
	//        FacebookUser logUser( uid ,email,token) {
	//                if (uid==null  || email==null) {
	//                        log.error "could not retrieve username as either uid or email were not given"
	//                        return null
	//                }
	//
	//                // try to resolve FacebookUser by uid
	//                def fbUser = FacebookUser.findByUid(uid)
	//
	//                // if found, just return the associated username
	//                if (fbUser) {
	//                        return fbUser
	//                }
	//                // else try to resolve user by email
	//				def rusr=RealUser.findByUsername(email)
	//                // create a new user if no relationship could be resolved
	//                return rusr?getAndUpdateUser(uid ,rusr,token):create( uid ,token)
	//        }
	//	FacebookUser getAndUpdateUser( uid ,person,token){
	//        log.info("Create facebook domain user $uid")
	//		def userRole=Role.findByAuthority("ROLE_USER")?:new Role(authority:"ROLE_USER").save(flush:true)
	//		def userRole1=Role.findByAuthority("ROLE_FACEBOOK")?:new Role(authority:"ROLE_FACEBOOK").save(flush:true)
	//		UserRole.create(person, userRole)
	//		UserRole.create(person, userRole1)
	//		FacebookUser fbUser = new FacebookUser(
	//				uid: uid,
	//				accessToken: token,
	//				user: person
	//		)
	//		fbUser.save(flush:true)
	//		fbUser.errors.each {
	//			log.debug( it)
	//		}
	//
	//		return fbUser
	//
	//	}
	//    FacebookUser create( uid ,token) {
	//        log.info("Create domain for facebook user $uid")
	//		Facebook facebook = new FacebookTemplate(token)
	//		FacebookProfile fbProfile = facebook.userOperations().userProfile
	//		String email = fbProfile.getEmail()
	//		String firstName=fbProfile.getFirstName()!=null?fbProfile.getFirstName():uid
	//		String lastName=fbProfile.getLastName()!=null?fbProfile.getLastName() :uid
	//        def person = new RealUser(
	//                username: email,
	//                email: email,
	//                password: '$uid',
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
	//        )
	//        person.save(flush:true)
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
	//                accessToken: token.accessToken,
	//                user: person
	//        )
	//        fbUser.save(flush:true)
	//		fbUser.errors.each {
	//        	log.debug( it)
	//		}
	//        return fbUser
	//    }



}

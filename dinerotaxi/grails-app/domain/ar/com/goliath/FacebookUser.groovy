package ar.com.goliath

import ar.com.goliath.RealUser

class FacebookUser {

	long uid
    String accessToken

	static belongsTo = [user: RealUser]

	static constraints = {
		uid unique: true
	}
}

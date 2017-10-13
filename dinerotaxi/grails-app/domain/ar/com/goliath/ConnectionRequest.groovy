package ar.com.goliath

class ConnectionRequest {

	String token = UUID.randomUUID().toString().replaceAll('-', '')
	Date dateCreated
	User fromUser
	User toUser
	String toUserEmail
	String message
	RequestStatus status = RequestStatus.PENDING
	
    static constraints = {
		fromUser(nullable: false)
		toUser(nullable: true)
		toUserEmail(nullable: false)
		message(blank: false, maxSize:200)
    }
    
    static List<ConnectionRequest> listMyConnectionRequests(User user) {
        ConnectionRequest.withCriteria {
            and {
                eq("toUserEmail", user.username)
                eq("status", RequestStatus.PENDING)
            }
        }
    }    
}

enum RequestStatus {
	PENDING, ACCEPTED, HIDDEN
}


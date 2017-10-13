package com


import ar.com.goliath.ConnectionRequest
import ar.com.goliath.User
import org.apache.commons.validator.EmailValidator
class ConnectionRequestCommand {
    def jmsService
    def emailService
	User fromUser
	String emailAddresses
	String message
	
	static constraints = {
		fromUser(nullable: true)
		message(nullable: true, maxSize:200)
		emailAddresses(blank: false, validator : { val, obj ->
				def emailValidator = EmailValidator.getInstance()
				for (email in val?.split(',')) {
					if (!emailValidator.isValid(email)) {
						// call errors.rejectValue(), or return false, or return an error code
						return "emailAddresses.invalid.email"
					}
				}
			})
	}
	protected boolean createRequests(ConnectionRequestCommand command) {
		for (email in command.emailAddresses.split(',')) {
			def user = User.findByUsername(email.toLowerCase().trim())
			def req = new ConnectionRequest(fromUser: command.fromUser, toUser: user, toUserEmail:email.trim().toLowerCase(), message: command.message).save(flush:true)
			def body = g.render(template:"/email/invitation", model:[req: req]).toString()
			
			emailService.send(email.trim().toLowerCase(), command.fromUser.username, "Invitiation to join 3baysover.com", body)
			eventLogService.logEvent(EventLogEvent.CreateInvitation.value(), "User ${command.fromUser.username} has sent invitation to ${email.trim().toLowerCase()}", command.fromUser, command.fromUser)
	   }
	   return true
	}
}

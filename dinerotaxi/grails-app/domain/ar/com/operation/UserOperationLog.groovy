package ar.com.operation

import java.util.Date;

import org.apache.commons.lang.builder.HashCodeBuilder

import ar.com.goliath.User

class UserOperationLog implements Serializable {

	User user
	Operation operation
	TRANSACTIONSTATUS status
	Integer code
	String reason
	Date createdDate
	Date lastModifiedDate
	def beforeInsert = { createdDate = new Date() }
	def beforeUpdate = { lastModifiedDate = new Date() }

	boolean equals(other) {
		if (!(other instanceof UserOperationLog)) {
			return false
		}

		other.user?.id == user?.id &&
			other.operation?.id == operation?.id
	}

	int hashCode() {
		def builder = new HashCodeBuilder()
		if (user) builder.append(user.id)
		if (operation) builder.append(operation.id)
		builder.toHashCode()
	}

	static UserOperationLog get(long userId, long operationId) {
		find 'from UserOperationLog where user.id=:userId and operation.id=:operationId',
			[userId: userId, operationId: operationId]
	}

	static UserOperationLog create(User user, Operation operation, boolean flush = false) {
		new UserOperationLog(user: user, operation: operation).save(flush: flush, insert: true)
	}

	static boolean remove(User user, Operation operation, boolean flush = false) {
		UserOperationLog instance = UserOperationLog.findByUserAndOperation(user, operation)
		instance ? instance.delete(flush: flush) : false
	}

	static void removeAll(User user) {
		executeUpdate 'DELETE FROM UserOperationLog WHERE user=:user', [user: user]
	}

	static void removeAll(Operation operation) {
		executeUpdate 'DELETE FROM UserOperationLog WHERE operation=:operation', [operation: operation]
	}
	
	static mapping = {
		code defaultValue:0
		status defaultValue:'CANCELED_DRIVER'
		reason defaultValue:''
		version false
	}
}


package ar.com.goliath
import org.apache.commons.lang.builder.HashCodeBuilder

import ar.com.imported.*
import ar.com.operation.OnlineRadioTaxi
import ar.com.operation.Operation
class BlackListRadioTaxiOperation implements Serializable {
	Company user
	Operation operation
	Date createdDate
	def beforeInsert = {
		createdDate = new Date()
	}
	static constraints = {
		createdDate(nullable:true,blank:true)
	}
	boolean equals(other) {
		if (!(other instanceof BlackListRadioTaxiOperation)) {
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

	static BlackListRadioTaxiOperation get(long userId, long operationId) {
		find 'from BlackListRadioTaxiOperation where user.id=:userId and operation.id=:operationId',
			[userId: userId, operationId: operationId]
	}

	static BlackListRadioTaxiOperation create(EmployUser user, Operation operation, boolean flush = false) {
		new BlackListRadioTaxiOperation(user: user, operation: operation).save(flush: flush, insert: true)
	}

	static boolean remove(EmployUser user, Operation operation, boolean flush = false) {
		BlackListRadioTaxiOperation instance = BlackListRadioTaxiOperation.findByUserAndOperation(user, operation)
		instance ? instance.delete(flush: flush) : false
	}

	static void removeAll(EmployUser user) {
		executeUpdate 'DELETE FROM BlackListRadioTaxiOperation WHERE user=:user', [user: user]
	}

	static void removeAll(Operation operation) {
		executeUpdate 'DELETE FROM BlackListRadioTaxiOperation WHERE operation=:operation', [operation: operation]
	}

	static mapping = {
		id composite: ['operation', 'user']
		version false
	}
}


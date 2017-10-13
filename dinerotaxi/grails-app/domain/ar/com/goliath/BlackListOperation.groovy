
package ar.com.goliath
import com.sun.org.apache.xalan.internal.xsltc.compiler.Import;

import java.io.Serializable;
import java.util.SortedSet;
import org.apache.commons.lang.builder.HashCodeBuilder

import ar.com.imported.*
import ar.com.operation.Operation
import ar.com.goliath.EmployUser
import com.Device
class BlackListOperation implements Serializable {
	EmployUser user
	Operation operation
	Date createdDate
	def beforeInsert = {
		createdDate = new Date()
	}
	static constraints = {
		createdDate(nullable:true,blank:true)
	}
	boolean equals(other) {
		if (!(other instanceof BlackListOperation)) {
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

	static BlackListOperation get(long userId, long operationId) {
		find 'from BlackListOperation where user.id=:userId and operation.id=:operationId',
			[userId: userId, operationId: operationId]
	}

	static BlackListOperation create(EmployUser user, Operation operation, boolean flush = false) {
		new BlackListOperation(user: user, operation: operation).save(flush: flush, insert: true)
	}

	static boolean remove(EmployUser user, Operation operation, boolean flush = false) {
		BlackListOperation instance = BlackListOperation.findByUserAndOperation(user, operation)
		instance ? instance.delete(flush: flush) : false
	}

	static void removeAll(EmployUser user) {
		executeUpdate 'DELETE FROM BlackListOperation WHERE user=:user', [user: user]
	}

	static void removeAll(Operation operation) {
		executeUpdate 'DELETE FROM BlackListOperation WHERE operation=:operation', [operation: operation]
	}

	static mapping = {
		id composite: ['operation', 'user']
		version false
	}
}


package ar.com.goliath.business

import org.apache.commons.lang.builder.HashCodeBuilder

import ar.com.goliath.User

class UserBusinessModel implements Serializable {

	User user
	BusinessModel businessModel

	boolean equals(other) {
		if (!(other instanceof UserBusinessModel)) {
			return false
		}

		other.user?.id == user?.id &&
			other.businessModel?.id == businessModel?.id
	}

	int hashCode() {
		def builder = new HashCodeBuilder()
		if (user) builder.append(user.id)
		if (businessModel) builder.append(businessModel.id)
		builder.toHashCode()
	}

	static UserBusinessModel get(long userId, long businessModelId) {
		find 'from UserBusinessModel where user.id=:userId and businessModel.id=:businessModelId',
			[userId: userId, businessModelId: businessModelId]
	}

	static UserBusinessModel create(User user, BusinessModel businessModel, boolean flush = false) {
		new UserBusinessModel(user: user, businessModel: businessModel).save(flush: flush, insert: true)
	}

	static boolean remove(User user, BusinessModel businessModel, boolean flush = false) {
		UserBusinessModel instance = UserBusinessModel.findByUserAndBusinessModel(user, businessModel)
		instance ? instance.delete(flush: flush) : false
	}

	static void removeAll(User user) {
		executeUpdate 'DELETE FROM UserBusinessModel WHERE user=:user', [user: user]
	}

	static void removeAll(BusinessModel businessModel) {
		executeUpdate 'DELETE FROM UserBusinessModel WHERE businessModel=:businessModel', [businessModel: businessModel]
	}
	
	static mapping = {
		id composite: ['businessModel', 'user']
		version false
	}
}

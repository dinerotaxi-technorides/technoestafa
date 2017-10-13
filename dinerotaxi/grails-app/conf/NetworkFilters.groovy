import ar.com.goliath.*

class NetworkFilters {
	def filters = {
		networks(controller:'*', action:'*') {
			before = {

				//def network = Network.findByCountry(params.country)
				//params.idNetwork = network.id
				def country = session["country"]
				if(country && !params?.country){
					params.country=country
				}
			}
		}
	}
}


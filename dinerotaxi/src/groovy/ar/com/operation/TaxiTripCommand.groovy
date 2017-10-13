
package ar.com.operation

public class TaxiTripCommand {
	def addressFrom,addressNumberFrom,latFrom,lngFrom,addressTo,addressNumberTo,latTo,lngTo,piso,dto,comments,firstName,lastName,id,status


	TaxiTripCommand(Operation el){
		id=el?.id
		addressFrom=el?.favorites?.placeFrom?.street
		addressNumberFrom=el?.favorites?.placeFrom?.streetNumber
		latFrom=el?.favorites?.placeFrom?.lat
		lngFrom=el?.favorites?.placeFrom?.lng
		status=el?.status.toString()
		addressTo=el?.favorites?.placeTo?.street
		addressNumberTo=el?.favorites?.placeTo?.streetNumber
		latTo=el?.favorites?.placeTo?.lat
		lngTo=el?.favorites?.placeTo?.lng

		piso = el?.favorites?.placeFromPso
		dto = el?.favorites?.placeFromDto
		comments=el?.favorites?.comments
		firstName=el?.user?.firstName
		lastName=el?.user?.lastName
	}
	TaxiTripCommand(OperationHistory el){
		id=el?.id
		addressFrom=el?.favorites?.placeFrom?.street
		addressNumberFrom=el?.favorites?.placeFrom?.streetNumber
		latFrom=el?.favorites?.placeFrom?.lat
		lngFrom=el?.favorites?.placeFrom?.lng
		status=el?.status.toString()

		addressTo=el?.favorites?.placeTo?.street
		addressNumberTo=el?.favorites?.placeTo?.streetNumber
		latTo=el?.favorites?.placeTo?.lat
		lngTo=el?.favorites?.placeTo?.lng

		piso = el?.favorites?.placeFromPso
		dto = el?.favorites?.placeFromDto
		comments=el?.favorites?.comments
		firstName=el?.user?.firstName
		lastName=el?.user?.lastName
	}
	TaxiTripCommand(OperationPending el){
		id=el?.id
		addressFrom=el?.favorites?.placeFrom?.street
		addressNumberFrom=el?.favorites?.placeFrom?.streetNumber
		latFrom=el?.favorites?.placeFrom?.lat
		lngFrom=el?.favorites?.placeFrom?.lng
		status=el?.status.toString()

		addressTo=el?.favorites?.placeTo?.street
		addressNumberTo=el?.favorites?.placeTo?.streetNumber
		latTo=el?.favorites?.placeTo?.lat
		lngTo=el?.favorites?.placeTo?.lng

		piso = el?.favorites?.placeFromPso
		dto = el?.favorites?.placeFromDto
		comments=el?.favorites?.comments
		firstName=el?.user?.firstName
		lastName=el?.user?.lastName
	}
}


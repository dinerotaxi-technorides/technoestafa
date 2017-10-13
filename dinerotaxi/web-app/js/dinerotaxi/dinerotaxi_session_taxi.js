/**
 * @author Wannataxi
 */

function createTaxiSession(id, sessionId, sessionSecret, expires) {
	setData("WT_TAXI_ID", id, expires);
	setData("WT_TAXI_SESSION_ID", sessionId, expires);
	setData("WT_TAXI_SESSION_SECRET", sessionSecret, expires);
}

function deleteTaxiSession() {
	deleteData("WT_TAXI_ID");
	deleteData("WT_TAXI_SESSION_ID");
	deleteData("WT_TAXI_SESSION_SECRET");
}
/**
 * @author Wannataxi
 */

function createUserSession(id, sessionId, sessionSecret, expires) {
	setData("WT_USER_ID", id, expires);
	setData("WT_USER_SESSION_ID", sessionId, expires);
	setData("WT_USER_SESSION_SECRET", sessionSecret, expires);
}

function deleteUserSession() {
	deleteData("WT_USER_ID");
	deleteData("WT_USER_SESSION_ID");
	deleteData("WT_USER_SESSION_SECRET");
}
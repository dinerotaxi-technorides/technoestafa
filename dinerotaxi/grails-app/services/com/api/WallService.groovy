package com.api

class WallService {
	
	public static final Integer rppWall=10
	public static final Integer rppWallReply=5

    static transactional = false

	def getWall (page, rpp, wallOwner) {
//		apiClientConnectionService.get("/search",[ob:'wallposts', toid:wallOwner, page:page, rpp:rpp, social:'facebook']).ans
	}
		
	def getWallpost(id){
//		apiClientConnectionService.get("/search", [ob:"wallpost",id:id, social:'facebook']).ans
	}
	
	def getPostReplies(wallpostid, page, rpp){
//		apiClientConnectionService.get("/search", [ob:"wallpost",id:wallpostid, page:page,rpp:rpp,social:'facebook']).ans		
	}
	
	def replyPost (userIdFrom, wallpostId, reply, social_id) {
//		reply = convertSymbols(reply)
//		def result = apiClientConnectionService.post("/users/${userIdFrom}/replies/posts/${wallpostId}", [REPLY:reply])
		def response=[]
//		if(!result.error){
//			if(result.location.split("/api/").size()>0){
//				response=apiClientConnectionService.get(result.location.split("/api")[1]).ans
//				response['user']['social_id']=social_id
//			}
//		}
		return response
	}
	
	def postToWall (userIdFrom, userIdTo, postText, facebookName, social_id) {
//		postText = convertSymbols(postText)
//		def result = apiClientConnectionService.post("/users/${userIdFrom}/posts", [TO:userIdTo, POST:postText])
		def response=[]
//		if(!result.error){
//			if(result.location.split("/api/").size()>0){
//				response=apiClientConnectionService.get(result.location.split("/api")[1]).ans
//				response['from']=['id':userIdFrom,'name':facebookName, social_id:social_id]
//			}
//		}
		return response
	}
	
	def likeReply(userID, replyID, vote){			
//		apiClientConnectionService.put("/users/${userID}/votes/replies/${replyID}/${vote.trim()}").ans
	}
	
	def likePost(userID, wallpostId, vote){
		//apiClientConnectionService.put("/users/${userID}/votes/posts/${wallpostId}/${vote.trim()}").ans
	}
	
	def deletePost(isAdmin,userId,userLoggedId,wallpostid){
		if (isAdmin){
			//apiClientConnectionService.delete("/admins/${userLoggedId}/users/${userId}/posts/${wallpostid}").ans
		}else{
			//apiClientConnectionService.delete("/users/${userId}/posts/${wallpostid}").ans	
		}
	}
	
	def deleteReply(isAdmin,userId, wallpostid, replyid,userLoggedId){
		if (isAdmin){
			//apiClientConnectionService.delete("/admins/${userLoggedId}/users/${userId}/replies/posts/${wallpostid}/${replyid}").ans
		}else{
			//apiClientConnectionService.delete("/users/${userId}/replies/posts/${wallpostid}/${replyid}").ans
		}
	}
	
}

package com.page

import grails.converters.JSON
import org.codehaus.groovy.grails.web.json.JSONObject


class WallController {		
	
	def wallService
	def commonService

    def index = { }
	
	def getRepliesAjax = {		
		def repliesPage=2
		if(!session.wpostRepliesPages.(params.wallpostid)){
			session.wpostRepliesPages.putAt(params.wallpostid, 2)
		}else{
			session.wpostRepliesPages.(params.wallpostid)++	
			repliesPage=session.wpostRepliesPages.(params.wallpostid)
		}
		def wallpostReplies = wallService.getPostReplies(params.wallpostid, repliesPage, wallService.rppWallReply)
//		wallpostReplies.replies=wallpostReplies.replies.reverse()	
		render(template:'/wall/tpl/wallpostreplies', model:[wallpost:wallpostReplies, hasMoreReplies:(wallpostReplies.replies_count>(repliesPage*wallService.rppWallReply))])
	}
	
	def getWallAjax = {
		if(params.fullWall!="true"){
			session.wallpostPageIndex++
		}else{
			session.wallpostPageIndex=1
		}
		JSONObject wallposts = wallService.getWall(session.wallpostPageIndex, wallService.rppWall, params.userOwner)	
		def hasMorePosts=(wallposts.wallPosts.size()>0);		
		render(template:'/wall/tpl/wallposts', model:[wallPosts:wallposts.wallPosts, hasMorePosts:hasMorePosts, hasMoreReplies:true, userToPost:params.userOwner])
	}
	
	def postToWallAjax = {
		if(params.new_post_content.toString().length()<20000){
			def wallpost = wallService.postToWall(session.userId, params.userIdTo, params.new_post_content,session.facebookName, session.facebookId)
			render(template:"/wall/tpl/wallpostItem", model:[wallpost:wallpost])			
		}else{
			render(['error':'20000 characters limit exceeded'] as JSON)
		}		
	}
	
	def postReply = {
		if(params.reply.toString().length()<20000){
			render(template:"/wall/tpl/wallpostReplyItem", model:[wallpost:['id':params.wallpostid],reply:wallService.replyPost(session.userId, params.wallpostid, params.reply, session.facebookId)])
		}else{
			render(['error':'20000 characters limit exceeded'] as JSON)
		}
	}	
	
	def likeReplyAjax = {
		wallService.likeReply(session.userId, params.replyid, params.vote)
		render ([] as JSON)
	}
	
	def likePostAjax = {
		wallService.likePost(session.userId, params.wallpostid, params.vote)
		def wallpost=wallService.getWallpost(params.wallpostid)
		render (template:'/wall/tpl/wallpostLikeButtons', model:[wallpost:wallpost])
	}
	
	//@Warning Fix This!
	def deletePost = {
//		Old version doesn't allow deleting other users posts(ie. profile wall owner can't delete posts done to him)
//		wallService.deletePost(session.userId, params.wallpostid)

//		TODO Fix This!
		wallService.deletePost(session.isAdmin,params.userId,session.userId,params.wallpostid)
		render([] as JSON)
	}
	
	//@Warning Fix This!
	def deleteReply = {
//		Old version doesn't allow deleting other users posts(ie. profile wall owner can't delete posts done to him)
//		wallService.deleteReply(session.userId, params.wallpostid, params.replyid)
//		TODO Fix This!
		wallService.deleteReply(session.isAdmin,params.userId, params.wallpostid, params.replyid,session.userId)
		render([] as JSON)
	}
	
	def renderWallPost = {
		JSONObject wallpost = wallService.getWallpost(params.id);
		render(template:'/wall/tpl/wallpostItem', model:[wallpost:wallpost])
	}
}

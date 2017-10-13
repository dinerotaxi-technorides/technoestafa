/* Copyright 2011 3BaysOver
 */
package com

import grails.converters.*

class MessageTagLib {
	def messageService
	def userService
	def linksForMessage = { attrs ->

		if( this.actionName.contains("open")){
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'pending']) { "Pending" }
			out<< " · "
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'archive']) { "Archive" }
			out<< " · "
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'close']) { "Close" }
		}else	if( this.actionName.contains("pending")){
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'open']) { "Open" }
			out<< " · "
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'archive']) { "Archive" }
			out<< " · "
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'close']) { "Close" }
		}else	if(this.actionName.contains("archived")){
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'open']) { "Open" }
			out<< " · "
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'pending']) { "Pending" }
			out<< " · "
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'close']) { "Close" }
		}else	if( this.actionName.contains("closed")){
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'open']) { "Open" }
			out<< " · "
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'pending']) { "Pending" }
			out<< " · "
			out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:this.actionName,to:'archive']) { "Archive" }
		}else if ( this.actionName.contains("details")){
			
			def act=messageService.readConversationFolder(attrs.id, userService.currentUser())
			if( act.toString().toLowerCase().contains("open")){
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'pending']) { "Pending" }
				out<< " · "
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'archive']) { "Archive" }
				out<< " ·  "
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'close']) { "Close" }
			}else	if( act.toString().toLowerCase().contains("pending")){
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'open']) { "Open" }
				out<< " · "
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'archive']) { "Archive" }
				out<< " ·  "
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'close']) { "Close" }
			}else if(act.toString().toLowerCase().contains("archived")){
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'open']) { "Open" }
				out<< " · "
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'pending']) { "Pending" }
				out<< " · "
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'close']) { "Close" }
			}else if( act.toString().toLowerCase().contains("closed")){
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'open']) { "Open" }
				out<< " · "
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'pending']) { "Pending" }
				out<< " ·  "
				out << g.link(controller:"message", action:"move", id:attrs.id,params:[from:act.toString().toLowerCase(),to:'archive']) { "Archive" }
			}
		}
	}
}


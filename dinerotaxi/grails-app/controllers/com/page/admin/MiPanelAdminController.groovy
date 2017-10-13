package com.page.admin
import ar.com.goliath.User
class MiPanelAdminController {
	def springSecurityService
	def placeService
	def onlineNotificationService
	def notificationService
	def index = {
		redirect action:'data'
	}
	def data = {
		[usr:springSecurityService.currentUser]
	}

	def saveModification={
		def userInstance=springSecurityService.currentUser
		if(userInstance) {
			
			userInstance.password = params.password
			userInstance.createdDate = new Date()
			userInstance.lastModifiedDate = new Date()
			if(!userInstance.hasErrors() && userInstance.save(flush:true)) {
				flash.message = message(code: 'mipanel.midata.save.message')

				redirect action:'data'
			}
			else {
				userInstance.errors.each{
					print it
				}
				flash.error = message(code: 'mipanel.midata.save.error.save')
				redirect action:'data'
			}
		}
		else {

			flash.error = message(code: 'mipanel.midata.save.error')
			redirect action:'data'
		}
	}

}

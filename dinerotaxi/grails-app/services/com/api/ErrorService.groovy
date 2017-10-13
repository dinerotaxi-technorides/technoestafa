package com.api

class ErrorService {

    static transactional = true

    def serviceMethod() {

    }
	
	def logError(String message){
		log.error(message);
	}
	
	def logError(String message,ArrayList <String> answers){
		answers.each{
			log.error(message + ": " + it)
		}
	}
	
	def logError(String message,String answer){
		log.error(message + ": " + answer)
	}
	
	def logError(String message,Exception e){
		log.error(message + ": " + e);
	}
	
	def logError(Exception e){
		log.error(e);
	}
	
	
}

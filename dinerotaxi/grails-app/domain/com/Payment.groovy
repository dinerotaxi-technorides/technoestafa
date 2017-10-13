package com

class Payment {
	String type
	Boolean allowed
	
    static constraints = {
    }
	
	String toString(){
		return type
	}
}

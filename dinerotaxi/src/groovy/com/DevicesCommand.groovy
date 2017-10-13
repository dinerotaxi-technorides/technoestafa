
package com

class DevicesCommand {
	String token
	String keyValue;
	String description;
	UserDevice dev
	static constraints = {
		keyValue blank: false,nullable:false
		description blank: false,nullable:false
	}
}


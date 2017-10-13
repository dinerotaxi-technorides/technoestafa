package com
import ar.com.operation.Operation
import java.util.Date;

import org.codehaus.groovy.grails.plugins.web.taglib.ApplicationTagLib
import ar.com.notification.OnlineNotification;
import ar.com.operation.TRANSACTIONSTATUS

class NotificationApiCommand {
	
	Long opId
	String status
	Long taxistaId
	NotificationApiCommand(OnlineNotification not, Operation op){
		opId=not.operation
		status=op.status
		taxistaId=op?.taxista?.id
	}
}

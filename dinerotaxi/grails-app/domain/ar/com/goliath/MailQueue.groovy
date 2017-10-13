package ar.com.goliath

class MailQueue {
    
    String to
    String from
    String subject
    String body
        
    MailQueueStatus status = MailQueueStatus.PENDING

    Date dateCreated
    Date lastUpdated
    
    static mapping = {
      from column: 'sender'
      to column: 'receiver'
    }
    
    static constraints = {
        to (nullable:false, maxSize:255)
        from (nullable:false, maxSize:255)
        subject (nullable:false, maxSize:255)
        body (nullable:false, maxSize:10000)
    }
}

enum MailQueueStatus {
    PENDING, SENT, FAILED
}


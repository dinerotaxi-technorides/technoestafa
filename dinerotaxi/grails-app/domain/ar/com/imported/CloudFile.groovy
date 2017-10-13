package ar.com.imported

import ar.com.goliath.User

class CloudFile implements Comparable {
    String  uuid = java.util.UUID.randomUUID().toString()
    String  url
    String  container
    String  filename
    String  mimeType
    Integer filesize = 0

    User    user
    String  caption

    Date dateCreated
    Date lastUpdated

    static belongsTo = [ User ]

    static constraints = {
        uuid (maxSize:36)
        url (maxSize:255, nullable:true)
        container (maxSize:32, nullable:true)
        filename (maxSize:255,nullable:true)
        mimeType (maxSize:30,nullable:true)
        user (nullable:false)
        caption (maxSize:30,nullable:true)
    }
    
    int compareTo(obj) {
        lastUpdated.compareTo(obj.lastUpdated)
    }
    
    def cloudFilesService
    
    def beforeInsert = {
    }

    def beforeUpdate = {
    }        

    def beforeDelete = {
    }        
}


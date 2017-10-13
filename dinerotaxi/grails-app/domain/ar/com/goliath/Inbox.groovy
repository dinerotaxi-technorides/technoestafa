package ar.com.goliath


class Inbox {
    
    Company rtaxi
    String from
    String subject
    String body
	boolean wasReaded = false
	boolean hasStar   = false
	boolean trashed   = false
    Date dateCreated
    Date lastUpdated
	
	INBOXSTATUS status=INBOXSTATUS.DRIVER
	def beforeInsert = {
		dateCreated = new Date()
		lastUpdated = new Date()
	}
    static mapping = {
      from column: 'sender'
    }
    
    static constraints = {
        rtaxi (nullable:false)
        from (nullable:false, maxSize:255)
        subject (nullable:false, maxSize:255)
        body (nullable:false, maxSize:10000)
    }
}


public enum INBOXSTATUS{
	DRIVER("DRIVER"),ENTERPRISE("ENTERPRISE"),PASSENGER("PASSENGER")
	private final String abbreviation;

    // Reverse-lookup map for getting a day from an abbreviation
    private static final Map<String, INBOXSTATUS> lookup = new HashMap<String, INBOXSTATUS>();

    static {
        for (INBOXSTATUS d :INBOXSTATUS.values()) {
            lookup.put(d.getAbbreviation(), d);
        }
    }

    private INBOXSTATUS(String abbreviation) {
        this.abbreviation = abbreviation;
    }

    public String getAbbreviation() {
        return abbreviation;
    }

    public static INBOXSTATUS get(String abbreviation) {
        return lookup.get(abbreviation);
    }
}
package org.springframework.security.web.authentication.rememberme;

import java.util.Date;

/**
 * @author Luke Taylor
 * @version $Id: PersistentRememberMeToken.java 2239 2007-11-10 15:42:21Z luke_t $
 */
public class MyPersistentRememberMeToken {
    private String username;
    private String series;
    private String tokenValue;
    private Date date;
    private Long rtaxi;

    public MyPersistentRememberMeToken(String username, String series, String tokenValue, Date date,Long rtaxi) {
        this.username = username;
        this.series = series;
        this.tokenValue = tokenValue;
        this.rtaxi=rtaxi;
        this.date = date;
    }

    public Long getRtaxi() {
        return rtaxi;
    }
    public String getUsername() {
        return username;
    }

    public String getSeries() {
        return series;
    }

    public String getTokenValue() {
        return tokenValue;
    }

    public Date getDate() {
        return date;
    }
}
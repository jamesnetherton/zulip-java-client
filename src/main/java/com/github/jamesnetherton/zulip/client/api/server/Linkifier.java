package com.github.jamesnetherton.zulip.client.api.server;

/**
 * Defines a Zulip linkifier.
 */
public class Linkifier {

    private String pattern;
    private String urlFormatString;
    private long id;

    public Linkifier(String pattern, String urlFormatString, long id) {
        this.pattern = pattern;
        this.urlFormatString = urlFormatString;
        this.id = id;
    }

    public long getId() {
        return id;
    }

    public String getPattern() {
        return pattern;
    }

    public String getUrlFormatString() {
        return urlFormatString;
    }
}

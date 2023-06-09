package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a Zulip linkifier.
 */
public class Linkifier {

    @JsonProperty
    private String pattern;
    @JsonProperty
    private String urlTemplate;
    @JsonProperty
    private long id;

    public long getId() {
        return id;
    }

    public String getPattern() {
        return pattern;
    }

    public String getUrlTemplate() {
        return urlTemplate;
    }
}

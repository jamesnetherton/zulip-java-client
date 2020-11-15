package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a Zulip event.
 */
public class Event {

    @JsonProperty
    private long id;

    @JsonProperty
    private String type;

    public long getId() {
        return id;
    }

    public String getType() {
        return type;
    }
}

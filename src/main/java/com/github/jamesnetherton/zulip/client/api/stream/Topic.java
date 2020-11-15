package com.github.jamesnetherton.zulip.client.api.stream;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a Zulip stream topic.
 */
public class Topic {

    @JsonProperty
    private long maxId;

    @JsonProperty
    private String name;

    public long getMaxId() {
        return maxId;
    }

    public String getName() {
        return name;
    }
}

package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a Zulip custom emoji.
 */
public class CustomEmoji {

    @JsonProperty
    private long id;

    @JsonProperty
    private String name;

    @JsonProperty
    private String sourceUrl;

    @JsonProperty
    private boolean deactivated;

    @JsonProperty
    private long authorId;

    public long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getSourceUrl() {
        return sourceUrl;
    }

    public boolean isDeactivated() {
        return deactivated;
    }

    public long getAuthorId() {
        return authorId;
    }
}

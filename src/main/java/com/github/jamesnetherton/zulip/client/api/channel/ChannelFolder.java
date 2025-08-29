package com.github.jamesnetherton.zulip.client.api.channel;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

/**
 * Defines a Zulip channel folder.
 */
public class ChannelFolder {
    @JsonProperty
    private String name;

    @JsonProperty
    private Instant dateCreated;

    @JsonProperty
    private int creatorId;

    @JsonProperty
    private String description;

    @JsonProperty
    private String renderedDescription;

    @JsonProperty
    private int order;

    @JsonProperty
    private int id;

    @JsonProperty("is_archived")
    private boolean archived;

    public String getName() {
        return name;
    }

    public Instant getDateCreated() {
        return dateCreated;
    }

    public int getCreatorId() {
        return creatorId;
    }

    public String getDescription() {
        return description;
    }

    public String getRenderedDescription() {
        return renderedDescription;
    }

    public int getOrder() {
        return order;
    }

    public int getId() {
        return id;
    }

    public boolean isArchived() {
        return archived;
    }
}

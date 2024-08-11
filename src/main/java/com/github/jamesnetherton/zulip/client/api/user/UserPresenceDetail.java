package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

/**
 * Defines details about Zulip user presence.
 */
public class UserPresenceDetail {
    @JsonProperty
    private String client;

    @JsonProperty
    private UserPresenceStatus status;

    @JsonProperty
    private Instant timestamp;

    @JsonProperty
    private Instant activeTimestamp;

    @JsonProperty
    private Instant idleTimestamp;

    @JsonProperty
    private boolean pushable;

    public String getClient() {
        return client;
    }

    public UserPresenceStatus getStatus() {
        return status;
    }

    public Instant getTimestamp() {
        return timestamp;
    }

    public Instant getActiveTimestamp() {
        return activeTimestamp;
    }

    public Instant getIdleTimestamp() {
        return idleTimestamp;
    }

    public boolean isPushable() {
        return pushable;
    }
}

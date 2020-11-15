package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

/**
 * Defines details about Zulip user presence.
 */
public class UserPresenceDetail {

    @JsonProperty
    private UserPresenceStatus status;

    @JsonProperty
    private Instant timestamp;

    public UserPresenceStatus getStatus() {
        return status;
    }

    public Instant getTimestamp() {
        return timestamp;
    }
}

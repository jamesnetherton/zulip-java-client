package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a user referenced by a {@link TypingEvent}.
 */
public class TypingUser {

    @JsonProperty
    private long userId;

    @JsonProperty
    private String email;

    public long getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }
}

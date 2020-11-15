package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines the recipient of a Zulip message.
 */
public class MessageRecipient {

    @JsonProperty
    private String email;

    @JsonProperty
    private String fullName;

    @JsonProperty
    private long id;

    @JsonProperty
    private boolean isMirrorDummy;

    public MessageRecipient(String email, String fullName, long id, boolean mirrorDummy) {
        this.email = email;
        this.fullName = fullName;
        this.id = id;
        this.isMirrorDummy = mirrorDummy;
    }

    public String getEmail() {
        return email;
    }

    public String getFullName() {
        return fullName;
    }

    public long getId() {
        return id;
    }

    public boolean isMirrorDummy() {
        return isMirrorDummy;
    }
}

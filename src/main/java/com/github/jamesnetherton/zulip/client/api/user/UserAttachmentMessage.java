package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

/**
 * Defines a Zulip user attachment and its association with a message.
 */
public class UserAttachmentMessage {

    @JsonProperty
    private Instant dateSent;

    @JsonProperty
    private long id;

    public long getId() {
        return id;
    }

    public Instant getDateSent() {
        return dateSent;
    }
}

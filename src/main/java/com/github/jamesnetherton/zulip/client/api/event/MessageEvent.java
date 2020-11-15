package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.Message;

/**
 * Defines a Zulip event for receiving a {@link Message}.
 */
public class MessageEvent extends Event {

    @JsonProperty
    private Message message;

    public Message getMessage() {
        return message;
    }
}

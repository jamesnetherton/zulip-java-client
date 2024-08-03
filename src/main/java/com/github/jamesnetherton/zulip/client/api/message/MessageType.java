package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the type of Zulip message.
 */
public enum MessageType {
    /**
     * The message is a channel message.
     */
    CHANNEL,
    /**
     * The message is a direct message.
     */
    DIRECT,
    /**
     * The message is private.
     */
    PRIVATE,
    /**
     * The message is a stream message.
     */
    STREAM;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }

    @JsonCreator
    public static MessageType fromString(String type) {
        return MessageType.valueOf(type.toUpperCase());
    }
}

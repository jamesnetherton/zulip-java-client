package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines a flag associated with a message.
 */
public enum MessageFlag {
    /**
     * Whether the message is collapsed.
     */
    COLLAPSED,
    /**
     * Whether the message contains one of the user alert words.
     */
    HAS_ALERT_WORD,
    /**
     * Messages that are part of the users history.
     */
    HISTORICAL,
    /**
     * Whether the user was mentioned by this message.
     */
    MENTIONED,
    /**
     * Whether the message has been read by the user.
     */
    READ,
    /**
     * Whether the message has been starred.
     */
    STARRED,
    /**
     * Whether the message contained a wildcard mention such as @all.
     */
    WILDCARD_MENTIONED;

    @JsonCreator
    public static MessageFlag fromString(String flag) {
        return MessageFlag.valueOf(flag.toUpperCase());
    }

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

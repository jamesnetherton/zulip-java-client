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
     * Whether this message contained either a stream wildcard mention.
     */
    STREAM_WILDCARD_MENTIONED,
    /**
     * Whether this message contained a topic wildcard mention.
     */
    TOPIC_WILDCARD_MENTIONED,
    /**
     * Whether the message contained a wildcard mention such as @all.
     *
     * @deprecated use {@code MessageFlag.STREAM_WILDCARD_MENTIONED} or {@code MessageFlag.TOPIC_WILDCARD_MENTIONED}.
     */
    @Deprecated
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

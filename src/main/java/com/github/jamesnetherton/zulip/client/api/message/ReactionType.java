package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the Zulip emoji reaction type.
 */
public enum ReactionType {
    /**
     * Unicode emoji.
     */
    UNICODE,
    /**
     * Custom emoji.
     */
    REALM,
    /**
     * Special emoji included with Zulip.
     */
    ZULIP_EXTRA;

    @JsonCreator
    public static ReactionType fromString(String type) {
        if (type == null || type.isEmpty()) {
            return ReactionType.UNICODE;
        }
        return ReactionType.valueOf(type.toUpperCase().replace("_EMOJI", ""));
    }

    @Override
    public String toString() {
        return this.name().toLowerCase() + "_emoji";
    }
}

package com.github.jamesnetherton.zulip.client.api.message;

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

    @Override
    public String toString() {
        return this.name().toLowerCase() + "_emoji";
    }
}

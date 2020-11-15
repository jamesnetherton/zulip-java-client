package com.github.jamesnetherton.zulip.client.api.message;

/**
 * Defines anchor options for matching messages.
 */
public enum Anchor {
    /**
     * The oldest unread message matching the query, if any; otherwise, the most recent message.
     */
    FIRST_UNREAD,
    /**
     * The most recent message.
     */
    NEWEST,
    /**
     * The oldest message.
     */
    OLDEST;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

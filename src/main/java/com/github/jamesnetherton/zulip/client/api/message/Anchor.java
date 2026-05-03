package com.github.jamesnetherton.zulip.client.api.message;

/**
 * Defines anchor options for matching messages.
 */
public enum Anchor {
    /**
     * The first message on or after the datetime indicated by the {@code anchor_date} parameter, if any; otherwise, the most
     * recent message.
     *
     * @see <a href=
     *      "https://zulip.com/api/get-messages#parameter-anchor">https://zulip.com/api/get-messages#parameter-anchor</a>
     */
    DATE,
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

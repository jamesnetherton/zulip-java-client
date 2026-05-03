package com.github.jamesnetherton.zulip.client.api.user;

/**
 * Defines options for the Zulip UI web home view.
 */
public enum WebHomeView {
    /**
     * Combined feed view.
     */
    ALL_MESSAGES,
    /**
     * Inbox view.
     */
    INBOX,
    /**
     * Recent conversations view.
     */
    RECENT;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

package com.github.jamesnetherton.zulip.client.api.user;

/**
 * Defines options for the Zulip UI default view.
 */
public enum DefaultView {
    ALL_MESSAGES,
    RECENT_TOPICS;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

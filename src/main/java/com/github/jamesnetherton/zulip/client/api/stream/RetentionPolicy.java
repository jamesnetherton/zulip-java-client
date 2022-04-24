package com.github.jamesnetherton.zulip.client.api.stream;

/**
 * Defines the type of message retention policy.
 *
 * See <a href="https://zulip.com/help/message-retention-policy">https://zulip.com/help/message-retention-policy</a>
 */
public enum RetentionPolicy {
    /**
     * Retain unlimited messages.
     */
    UNLIMITED,

    /**
     * Use organization level message retention defaults.
     */
    REALM_DEFAULT;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

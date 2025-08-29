package com.github.jamesnetherton.zulip.client.api.user;

/**
 * Defines settings for whether the resolved-topic notices are marked as read.
 */
public enum ResolvedTopicNoticeAutoReadPolicy {
    /**
     * Always mark resolved-topic notices as read.
     */
    ALWAYS,
    /**
     * Mark resolved-topic notices as read in topics not followed by the user.
     */
    EXCEPT_FOLLOWED,
    /**
     * Never mark resolved topic notices as read.
     */
    NEVER;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

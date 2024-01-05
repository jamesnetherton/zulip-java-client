package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the policy for topic following.
 *
 * See <a href=
 * "https://zulip.com/api/update-realm-user-settings-defaults#parameter-automatically_follow_topics_policy">https://zulip.com/api/update-realm-user-settings-defaults#parameter-automatically_follow_topics_policy</a>
 */
public enum TopicFollowPolicy {
    /**
     * Topics the user participates in.
     */
    PARTICIPATING(1),
    /**
     * Topics the user sends a message to.
     */
    SENT_MESSAGE(2),
    /**
     * Topics the user starts.
     */
    USER_STARTED(3),
    /**
     * Never.
     */
    NEVER(4),
    /**
     * Unknown policy.
     */
    UNKNOWN(0);

    private final int id;

    TopicFollowPolicy(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static TopicFollowPolicy fromInt(int id) {
        for (TopicFollowPolicy topicFollowPolicy : TopicFollowPolicy.values()) {
            if (topicFollowPolicy.getId() == id) {
                return topicFollowPolicy;
            }
        }
        return UNKNOWN;
    }
}

package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the policy for unmute topic in muted streams.
 *
 * See <a href=
 * "https://zulip.com/api/update-realm-user-settings-defaults#parameter-automatically_unmute_topics_in_muted_streams_policy">https://zulip.com/api/update-realm-user-settings-defaults#parameter-automatically_unmute_topics_in_muted_streams_policy</a>
 */
public enum UnmuteTopicInMutedStreamsPolicy {
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

    UnmuteTopicInMutedStreamsPolicy(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static UnmuteTopicInMutedStreamsPolicy fromInt(int id) {
        for (UnmuteTopicInMutedStreamsPolicy topicFollowPolicy : UnmuteTopicInMutedStreamsPolicy.values()) {
            if (topicFollowPolicy.getId() == id) {
                return topicFollowPolicy;
            }
        }
        return UNKNOWN;
    }
}

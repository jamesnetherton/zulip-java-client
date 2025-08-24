package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum TopicPolicy {
    /**
     * Messages can be sent to both named topics and the empty topic in this channel.
     */
    ALLOW_EMPTY_TOPIC,
    /**
     * Messages can be sent to named topics in this channel, but the empty topic is disabled.
     */
    DISABLE_EMPTY_TOPIC,
    /**
     * Messages can be sent to the empty topic in this channel, but named topics are disabled
     */
    EMPTY_TOPIC_ONLY,
    /**
     * Messages can be sent to named topics in this channel, and the organization-level realm_topics_policy is used for whether
     * messages can be sent to the empty topic in this channel
     */
    INHERIT;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }

    @JsonCreator
    public static TopicPolicy fromString(String policy) {
        return TopicPolicy.valueOf(policy.toUpperCase());
    }
}

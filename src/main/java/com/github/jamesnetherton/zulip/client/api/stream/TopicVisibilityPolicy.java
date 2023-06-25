package com.github.jamesnetherton.zulip.client.api.stream;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the type of topic visibility policy.
 *
 * See <a href=
 * "https://zulip.com/api/update-user-topic#parameter-visibility_policy">https://zulip.com/api/update-user-topic#parameter-visibility_policy</a>
 */
public enum TopicVisibilityPolicy {
    /**
     * Removes the visibility policy previously set for the topic.
     */
    NONE(0),
    /**
     * Mutes the topic in a stream.
     */
    MUTED(1),
    /**
     * Unmutes the topic in a muted stream.
     */
    UNMUTED(2);

    private int id;

    TopicVisibilityPolicy(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static TopicVisibilityPolicy fromInt(int visibilityPolicy) {
        for (TopicVisibilityPolicy topicVisibilityPolicy : TopicVisibilityPolicy.values()) {
            if (topicVisibilityPolicy.getId() == visibilityPolicy) {
                return topicVisibilityPolicy;
            }
        }
        return NONE;
    }
}

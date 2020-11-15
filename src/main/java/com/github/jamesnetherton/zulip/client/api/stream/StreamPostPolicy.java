package com.github.jamesnetherton.zulip.client.api.stream;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the stream post policy.
 */
public enum StreamPostPolicy {
    /**
     * Any user can post to the stream.
     */
    ANY(1),
    /**
     * Only administrators can post to the stream.
     */
    ADMIN_ONLY(2),
    /**
     * Only new members can post to the stream.
     */
    NEW_MEMBERS_ONLY(3),
    /**
     * An unknown post policy. This usually indicates an error in the response from Zulip.
     */
    UNKNOWN(0);

    private final int id;

    StreamPostPolicy(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static StreamPostPolicy fromInt(int policy) {
        for (StreamPostPolicy postPolicy : StreamPostPolicy.values()) {
            if (postPolicy.getId() == policy) {
                return postPolicy;
            }
        }
        return UNKNOWN;
    }
}

package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the user presence status.
 */
public enum UserPresenceStatus {
    /**
     * The user is active on Zulip.
     */
    ACTIVE,
    /**
     * The user is idle on Zulip.
     */
    IDLE,
    /**
     * The user is offline.
     */
    OFFLINE;

    @JsonCreator
    public static UserPresenceStatus fromString(String status) {
        return UserPresenceStatus.valueOf(status.toUpperCase());
    }
}

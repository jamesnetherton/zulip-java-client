package com.github.jamesnetherton.zulip.client.api.user;

/**
 * Defines settings for the style selected by the user for the right sidebar user list.
 */
public enum UserListStyle {
    COMPACT(1),
    WITH_STATUS(2),
    WITH_AVATAR_AND_STATUS(3);

    private final int id;

    UserListStyle(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}

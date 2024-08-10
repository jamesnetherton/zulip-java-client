package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines Zulip user roles.
 */
public enum UserRole {
    /**
     * Organization owner role.
     */
    ORGANIZATION_OWNER(100),
    /**
     * Organization administrator role.
     */
    ORGANIZATION_ADMIN(200),
    /**
     * Organization moderator role.
     */
    ORGANIZATION_MODERATOR(300),
    /**
     * Member role.
     */
    MEMBER(400),
    /**
     * Guest role.
     */
    GUEST(600),
    /**
     * Unknown role.
     */
    UNKNOWN(999);

    private final int id;

    UserRole(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static UserRole fromInt(int userRole) {
        for (UserRole role : UserRole.values()) {
            if (role.getId() == userRole) {
                return role;
            }
        }
        return UNKNOWN;
    }
}

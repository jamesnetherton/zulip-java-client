package com.github.jamesnetherton.zulip.client.api.user;

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
    GUEST(600);

    private final int id;

    UserRole(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}

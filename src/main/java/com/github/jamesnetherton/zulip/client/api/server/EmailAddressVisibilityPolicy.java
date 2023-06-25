package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum EmailAddressVisibilityPolicy {
    EVERYONE(1),
    MEMBERS(2),
    ADMINISTRATORS(3),
    NOBODY(4),
    MODERATORS(5);

    private final int id;

    EmailAddressVisibilityPolicy(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static EmailAddressVisibilityPolicy fromInt(int addressVisibilityPolicy) {
        for (EmailAddressVisibilityPolicy emailAddressVisibilityPolicy : EmailAddressVisibilityPolicy.values()) {
            if (emailAddressVisibilityPolicy.getId() == addressVisibilityPolicy) {
                return emailAddressVisibilityPolicy;
            }
        }
        return NOBODY;
    }
}

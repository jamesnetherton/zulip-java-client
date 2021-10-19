package com.github.jamesnetherton.zulip.client.api.draft;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum DraftType {
    /**
     * The draft is private.
     */
    PRIVATE,
    /**
     * The draft is a stream message.
     */
    STREAM,
    /**
     * The draft is unaddressed.
     */
    UNADDRESSED;

    @Override
    public String toString() {
        if (this == UNADDRESSED) {
            return "";
        }
        return this.name().toLowerCase();
    }

    @JsonCreator
    public static DraftType fromString(String type) {
        if (type == null || type.isEmpty()) {
            return DraftType.UNADDRESSED;
        }
        return DraftType.valueOf(type.toUpperCase());
    }

}

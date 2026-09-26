package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the operation that an {@link Event} describes.
 */
public enum EventOperation {
    ADD,
    REMOVE,
    START,
    STOP;

    @JsonCreator
    public static EventOperation fromString(String operation) {
        return EventOperation.valueOf(operation.toUpperCase());
    }

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

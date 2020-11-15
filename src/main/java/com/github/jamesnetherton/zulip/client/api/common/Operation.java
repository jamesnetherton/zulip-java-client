package com.github.jamesnetherton.zulip.client.api.common;

/**
 * Defines an operation to apply.
 */
public enum Operation {
    /**
     * Adds a property to a Zulip object
     */
    ADD,
    /**
     * Removes a property from a Zulip object.
     */
    REMOVE;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

package com.github.jamesnetherton.zulip.client.api.user;

/**
 * Defines a typing operation.
 */
public enum TypingOperation {
    /**
     * The user has started to type.
     */
    START,
    /**
     * The user has stopped typing.
     */
    STOP;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

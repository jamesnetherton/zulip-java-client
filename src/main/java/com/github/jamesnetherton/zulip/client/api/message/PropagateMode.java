package com.github.jamesnetherton.zulip.client.api.message;

/**
 * Defines the Zulip message edit propagation mode and determines which message(s) should be edited.
 */
public enum PropagateMode {
    /**
     * Changes the message specified by the provided message id.
     */
    CHANGE_ONE,
    /**
     * Changes messages in the topic that had been sent before the one specified.
     */
    CHANGE_LATER,
    /**
     * Changes all messages.
     */
    CHANGE_ALL;

    @Override
    public String toString() {
        return this.name().toLowerCase();
    }
}

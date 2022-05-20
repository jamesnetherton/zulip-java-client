package com.github.jamesnetherton.zulip.client.api.user;

/**
 * Options for the control of inactive stream demotion.
 */
public enum DemoteInactiveStreamOption {
    AUTOMATIC(1),
    ALWAYS(2),
    NEVER(3);

    private final int id;

    private DemoteInactiveStreamOption(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }
}

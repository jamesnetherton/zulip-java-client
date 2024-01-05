package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the mark read policy for when a user scrolls through their feed.
 *
 * See <a href=
 * "https://zulip.com/api/update-settings#parameter-web_mark_read_on_scroll_policy">https://zulip.com/api/update-settings#parameter-web_mark_read_on_scroll_policy</a>
 */
public enum MarkReadOnScrollPolicy {
    /**
     * Messages are always marked as read.
     */
    ALWAYS(1),
    /**
     * Messages are only marked as read in conversation views.
     */
    CONSERVATION_VIEWS(2),
    /**
     * Messages are never marked as read.
     */
    NEVER(3);

    private final int id;

    MarkReadOnScrollPolicy(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static MarkReadOnScrollPolicy fromInt(int readOnScrollPolicy) {
        for (MarkReadOnScrollPolicy markReadOnScrollPolicy : MarkReadOnScrollPolicy.values()) {
            if (markReadOnScrollPolicy.getId() == readOnScrollPolicy) {
                return markReadOnScrollPolicy;
            }
        }
        return ALWAYS;
    }
}

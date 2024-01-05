package com.github.jamesnetherton.zulip.client.api.server;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Defines the web stream unread count display policy.
 *
 * See <a href=
 * "https://zulip.com/api/update-realm-user-settings-defaults#parameter-web_stream_unreads_count_display_policy">https://zulip.com/api/update-realm-user-settings-defaults#parameter-web_stream_unreads_count_display_policy</a>
 */
public enum WebStreamUnreadsCountDisplayPolicy {
    ALL_STREAMS(1),
    UNMUTED_STREAMS_TOPICS(2),
    NO_STREAMS(3);

    private final int id;

    WebStreamUnreadsCountDisplayPolicy(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static WebStreamUnreadsCountDisplayPolicy fromInt(int webStreamUnreadsCountDisplayPolicy) {
        for (WebStreamUnreadsCountDisplayPolicy policy : WebStreamUnreadsCountDisplayPolicy.values()) {
            if (policy.getId() == webStreamUnreadsCountDisplayPolicy) {
                return policy;
            }
        }
        return ALL_STREAMS;
    }
}

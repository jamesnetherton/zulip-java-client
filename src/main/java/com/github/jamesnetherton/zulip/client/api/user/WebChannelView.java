package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonCreator;

/**
 * Setting for controlling the default navigation behavior when clicking on a channel link
 */
public enum WebChannelView {
    /**
     * Top topic in the channel.
     */
    CHANNEL_TOP_TOPIC(1),
    /**
     * Channel feed.
     */
    CHANNEL_FEED(2),
    /**
     * List of topics.
     */
    LIST_OF_TOPICS(3),
    /**
     * Top unread topic in channel.
     */
    TOP_UNREAD_TOPIC_IN_CHANNEL(4);

    private final int id;

    WebChannelView(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    @JsonCreator
    public static WebChannelView fromInt(int id) {
        for (WebChannelView webChannelView : WebChannelView.values()) {
            if (webChannelView.getId() == id) {
                return webChannelView;
            }
        }
        return null;
    }
}

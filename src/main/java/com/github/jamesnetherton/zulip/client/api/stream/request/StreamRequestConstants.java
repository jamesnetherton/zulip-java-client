package com.github.jamesnetherton.zulip.client.api.stream.request;

final class StreamRequestConstants {

    public static final String STREAM_ID = "get_stream_id";
    public static final String STREAM_TOPICS = "users/me/%d/topics";
    public static final String STREAMS = "streams";
    public static final String STREAMS_WITH_ID = STREAMS + "/%d";
    public static final String SUBSCRIPTIONS = "users/me/subscriptions";
    public static final String MUTED_TOPICS = SUBSCRIPTIONS + "/muted_topics";
    public static final String SUBSCRIPTIONS_PROPERTIES = SUBSCRIPTIONS + "/properties";
    public static final String TOPIC_DELETE = STREAMS_WITH_ID + "/delete_topic";
    public static final String USER_SUBSCRIPTIONS = "users/%d/subscriptions/%d";
    public static final String USER_TOPICS = "user_topics";

    private StreamRequestConstants() {
    }
}

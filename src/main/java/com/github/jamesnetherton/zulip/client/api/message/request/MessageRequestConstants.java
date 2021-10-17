package com.github.jamesnetherton.zulip.client.api.message.request;

public class MessageRequestConstants {

    public static final String MARK_ALL_AS_READ = "mark_all_as_read";
    public static final String MARK_STREAM_AS_READ = "mark_stream_as_read";
    public static final String MARK_TOPIC_AS_READ = "mark_topic_as_read";
    public static final String MESSAGES_API_PATH = "messages";
    public static final String MESSAGES_ID_API_PATH = MESSAGES_API_PATH + "/%d";
    public static final String FLAGS_API_PATH = MESSAGES_API_PATH + "/flags";
    public static final String HISTORY_API_PATH = MESSAGES_ID_API_PATH + "/history";
    public static final String MATCHES_NARROW_API_PATH = MESSAGES_API_PATH + "/matches_narrow";
    public static final String REACTIONS_API_PATH = MESSAGES_ID_API_PATH + "/reactions";
    public static final String RENDER_MESSAGE_API_PATH = MESSAGES_API_PATH + "/render";
    public static final String USER_UPLOADS_API_PATH = "user_uploads";
    
    private MessageRequestConstants() {
    }
}

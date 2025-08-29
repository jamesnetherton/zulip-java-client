package com.github.jamesnetherton.zulip.client.api.message.request;

final class MessageRequestConstants {

    final static String MARK_ALL_AS_READ = "mark_all_as_read";
    final static String MARK_STREAM_AS_READ = "mark_stream_as_read";
    final static String MARK_TOPIC_AS_READ = "mark_topic_as_read";
    final static String MESSAGES_API_PATH = "messages";
    final static String MESSAGES_ID_API_PATH = MESSAGES_API_PATH + "/%d";
    final static String FLAGS_API_PATH = MESSAGES_API_PATH + "/flags";
    final static String FLAGS_API_NARROW_PATH = FLAGS_API_PATH + "/narrow";
    final static String HISTORY_API_PATH = MESSAGES_ID_API_PATH + "/history";
    final static String MATCHES_NARROW_API_PATH = MESSAGES_API_PATH + "/matches_narrow";
    final static String MESSAGE_REMINDER_API_PATH = "reminders";
    final static String MESSAGE_REMINDER_ID_API_PATH = "reminders" + "/%d";
    final static String REACTIONS_API_PATH = MESSAGES_ID_API_PATH + "/reactions";
    final static String READ_RECEIPTS_API_PATH = MESSAGES_ID_API_PATH + "/read_receipts";
    final static String REPORT_MESSAGE_API_PATH = MESSAGES_ID_API_PATH + "/report";
    final static String RENDER_MESSAGE_API_PATH = MESSAGES_API_PATH + "/render";
    final static String SCHEDULED_MESSAGES_API_PATH = "scheduled_messages";
    final static String SCHEDULED_MESSAGES_ID_API_PATH = SCHEDULED_MESSAGES_API_PATH + "/%d";
    final static String USER_UPLOADS_API_PATH = "user_uploads";

    private MessageRequestConstants() {
    }
}

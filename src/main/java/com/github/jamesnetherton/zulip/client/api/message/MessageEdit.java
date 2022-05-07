package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

/**
 * Defines history for an edited Zulip message
 */
public class MessageEdit {

    @JsonProperty("prev_content")
    private String previousContent;

    @JsonProperty("prev_rendered_content")
    private String previousRenderedContent;

    @JsonProperty("prev_rendered_content_version")
    private long previousRenderedContentVersion;

    @JsonProperty("prev_stream")
    private long previousStream;

    @JsonProperty("prev_topic")
    private String previousTopic;

    @JsonProperty
    private long stream;

    @JsonProperty
    private Instant timestamp;

    @JsonProperty
    private String topic;

    @JsonProperty
    private long userId;

    public String getPreviousContent() {
        return previousContent;
    }

    public String getPreviousRenderedContent() {
        return previousRenderedContent;
    }

    public long getPreviousRenderedContentVersion() {
        return previousRenderedContentVersion;
    }

    public long getPreviousStream() {
        return previousStream;
    }

    public String getPreviousTopic() {
        return previousTopic;
    }

    public long getStream() {
        return stream;
    }

    public Instant getTimestamp() {
        return timestamp;
    }

    public String getTopic() {
        return topic;
    }

    public long getUserId() {
        return userId;
    }
}

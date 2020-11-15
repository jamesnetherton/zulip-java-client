package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;

/**
 * Defines the edit history of a Zulip message.
 */
public class MessageHistory {

    @JsonProperty
    private String content;

    @JsonProperty
    private String contentHtmlDiff;

    @JsonProperty("prev_content")
    private String previousContent;

    @JsonProperty("prev_rendered_content")
    private String previousRenderedContent;

    @JsonProperty("prev_topic")
    private String previousTopic;

    @JsonProperty
    private String renderedContent;

    @JsonProperty
    private Instant timestamp;

    @JsonProperty
    private String topic;

    @JsonProperty
    private long userId;

    public String getContent() {
        return content;
    }

    public String getContentHtmlDiff() {
        return contentHtmlDiff;
    }

    public String getPreviousContent() {
        return previousContent;
    }

    public String getPreviousRenderedContent() {
        return previousRenderedContent;
    }

    public String getPreviousTopic() {
        return previousTopic;
    }

    public String getRenderedContent() {
        return renderedContent;
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

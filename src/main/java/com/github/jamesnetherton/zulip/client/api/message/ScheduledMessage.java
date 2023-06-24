package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.databind.JsonNode;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public class ScheduledMessage {

    @JsonProperty
    private String content;

    @JsonProperty
    private boolean failed;

    @JsonProperty
    private String renderedContent;

    @JsonProperty
    private Instant scheduledDeliveryTimestamp;

    @JsonProperty
    private long scheduledMessageId;

    @JsonProperty
    private List<Long> to = new ArrayList<>();

    @JsonProperty
    private String topic;

    @JsonProperty
    private MessageType type;

    public String getContent() {
        return content;
    }

    public boolean isFailed() {
        return failed;
    }

    public String getRenderedContent() {
        return renderedContent;
    }

    public Instant getScheduledDeliveryTimestamp() {
        return scheduledDeliveryTimestamp;
    }

    public long getScheduledMessageId() {
        return scheduledMessageId;
    }

    public List<Long> getTo() {
        return to;
    }

    public String getTopic() {
        return topic;
    }

    public MessageType getType() {
        return type;
    }

    @JsonSetter("to")
    void setTo(JsonNode node) {
        if (node.isNumber()) {
            to.add(node.longValue());
        }

        if (node.isArray()) {
            node.forEach(jsonNode -> to.add(jsonNode.longValue()));
        }
    }
}

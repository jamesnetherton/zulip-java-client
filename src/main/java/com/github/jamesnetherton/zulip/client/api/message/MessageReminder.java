package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines a Zulip message reminder.
 */
public class MessageReminder {
    @JsonProperty
    private String content;

    @JsonProperty
    private boolean failed;

    @JsonProperty
    private int reminderId;

    @JsonProperty
    private int reminderTargetMessageId;

    @JsonProperty
    private String renderedContent;

    @JsonProperty
    private Instant scheduledDeliveryTimestamp;

    @JsonProperty
    private List<Integer> to = new ArrayList<>();

    @JsonProperty
    private MessageType type;

    public String getContent() {
        return content;
    }

    public boolean isFailed() {
        return failed;
    }

    public int getReminderId() {
        return reminderId;
    }

    public int getReminderTargetMessageId() {
        return reminderTargetMessageId;
    }

    public String getRenderedContent() {
        return renderedContent;
    }

    public Instant getScheduledDeliveryTimestamp() {
        return scheduledDeliveryTimestamp;
    }

    public List<Integer> getTo() {
        return to;
    }

    public MessageType getType() {
        return type;
    }
}

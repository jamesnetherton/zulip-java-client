package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.MessageType;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines a Zulip event for a user starting or stopping typing a message.
 *
 * @see <a href="https://zulip.com/api/get-events#typing-start">https://zulip.com/api/get-events#typing-start</a>
 */
public class TypingEvent extends Event {

    @JsonProperty
    private EventOperation op;

    @JsonProperty
    private MessageType messageType;

    @JsonProperty
    private TypingUser sender;

    @JsonProperty
    private List<TypingUser> recipients = new ArrayList<>();

    @JsonProperty
    private Long streamId;

    @JsonProperty
    private String topic;

    public EventOperation getOperation() {
        return op;
    }

    public MessageType getMessageType() {
        return messageType;
    }

    public TypingUser getSender() {
        return sender;
    }

    public List<TypingUser> getRecipients() {
        return recipients;
    }

    public Long getStreamId() {
        return streamId;
    }

    public String getTopic() {
        return topic;
    }
}

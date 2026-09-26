package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.MessageType;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines a Zulip event for message deletion.
 *
 * @see <a href="https://zulip.com/api/get-events#delete_message">https://zulip.com/api/get-events#delete_message</a>
 */
public class DeleteMessageEvent extends Event {

    @JsonProperty
    private List<Long> messageIds = new ArrayList<>();

    @JsonProperty
    private MessageType messageType;

    @JsonProperty
    private Long streamId;

    @JsonProperty
    private String topic;

    public List<Long> getMessageIds() {
        return messageIds;
    }

    public MessageType getMessageType() {
        return messageType;
    }

    public Long getStreamId() {
        return streamId;
    }

    public String getTopic() {
        return topic;
    }
}

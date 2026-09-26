package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.MessageType;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines the recipients of a message referenced by a {@link TypingEditMessageEvent}.
 */
public class TypingEditMessageRecipient {

    @JsonProperty
    private MessageType type;

    @JsonProperty
    private Long channelId;

    @JsonProperty
    private String topic;

    @JsonProperty
    private List<Long> userIds = new ArrayList<>();

    public MessageType getType() {
        return type;
    }

    public Long getChannelId() {
        return channelId;
    }

    public String getTopic() {
        return topic;
    }

    public List<Long> getUserIds() {
        return userIds;
    }
}

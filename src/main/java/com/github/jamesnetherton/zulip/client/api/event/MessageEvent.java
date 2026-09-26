package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.Message;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlag;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines a Zulip event for receiving a {@link Message}.
 *
 * @see <a href="https://zulip.com/api/get-events#message">https://zulip.com/api/get-events#message</a>
 */
public class MessageEvent extends Event {

    @JsonProperty
    private Message message;

    @JsonProperty
    private List<MessageFlag> flags = new ArrayList<>();

    public Message getMessage() {
        return message;
    }

    public List<MessageFlag> getFlags() {
        return flags;
    }
}

package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlag;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines a Zulip event for message flags being added or removed.
 *
 * @see <a href=
 *      "https://zulip.com/api/get-events#update_message_flags-add">https://zulip.com/api/get-events#update_message_flags-add</a>
 */
public class UpdateMessageFlagsEvent extends Event {

    @JsonProperty
    private EventOperation op;

    @JsonProperty
    private MessageFlag flag;

    @JsonProperty("messages")
    private List<Long> messageIds = new ArrayList<>();

    @JsonProperty
    private boolean all;

    public EventOperation getOperation() {
        return op;
    }

    public MessageFlag getFlag() {
        return flag;
    }

    public List<Long> getMessageIds() {
        return messageIds;
    }

    public boolean isAll() {
        return all;
    }
}

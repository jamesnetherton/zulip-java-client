package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a Zulip event for a user starting or stopping editing a message.
 *
 * @see <a href=
 *      "https://zulip.com/api/get-events#typing_edit_message-start">https://zulip.com/api/get-events#typing_edit_message-start</a>
 */
public class TypingEditMessageEvent extends Event {

    @JsonProperty
    private EventOperation op;

    @JsonProperty
    private long senderId;

    @JsonProperty
    private long messageId;

    @JsonProperty
    private TypingEditMessageRecipient recipient;

    public EventOperation getOperation() {
        return op;
    }

    public long getSenderId() {
        return senderId;
    }

    public long getMessageId() {
        return messageId;
    }

    public TypingEditMessageRecipient getRecipient() {
        return recipient;
    }
}

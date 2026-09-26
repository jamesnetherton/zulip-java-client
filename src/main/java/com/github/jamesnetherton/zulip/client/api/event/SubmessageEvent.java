package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a Zulip event for a submessage being added to a message.
 *
 * @see <a href="https://zulip.com/api/get-events#submessage">https://zulip.com/api/get-events#submessage</a>
 */
public class SubmessageEvent extends Event {

    @JsonProperty
    private String msgType;

    @JsonProperty
    private String content;

    @JsonProperty
    private long messageId;

    @JsonProperty
    private long senderId;

    @JsonProperty
    private long submessageId;

    public String getMsgType() {
        return msgType;
    }

    public String getContent() {
        return content;
    }

    public long getMessageId() {
        return messageId;
    }

    public long getSenderId() {
        return senderId;
    }

    public long getSubmessageId() {
        return submessageId;
    }
}

package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.message.MessageFlag;
import com.github.jamesnetherton.zulip.client.api.message.PropagateMode;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines a Zulip event for a message being edited or moved.
 *
 * @see <a href="https://zulip.com/api/get-events#update_message">https://zulip.com/api/get-events#update_message</a>
 */
public class UpdateMessageEvent extends Event {

    @JsonProperty
    private Long userId;

    @JsonProperty
    private boolean renderingOnly;

    @JsonProperty
    private long messageId;

    @JsonProperty
    private List<Long> messageIds = new ArrayList<>();

    @JsonProperty
    private List<MessageFlag> flags = new ArrayList<>();

    @JsonProperty
    private Instant editTimestamp;

    @JsonProperty
    private Long streamId;

    @JsonProperty
    private Long newStreamId;

    @JsonProperty
    private PropagateMode propagateMode;

    @JsonProperty
    private String origSubject;

    @JsonProperty
    private String subject;

    @JsonProperty
    private String origContent;

    @JsonProperty
    private String origRenderedContent;

    @JsonProperty
    private String content;

    @JsonProperty
    private String renderedContent;

    @JsonProperty
    private Boolean isMeMessage;

    public Long getUserId() {
        return userId;
    }

    public boolean isRenderingOnly() {
        return renderingOnly;
    }

    public long getMessageId() {
        return messageId;
    }

    public List<Long> getMessageIds() {
        return messageIds;
    }

    public List<MessageFlag> getFlags() {
        return flags;
    }

    public Instant getEditTimestamp() {
        return editTimestamp;
    }

    public Long getStreamId() {
        return streamId;
    }

    public Long getNewStreamId() {
        return newStreamId;
    }

    public PropagateMode getPropagateMode() {
        return propagateMode;
    }

    public String getOrigSubject() {
        return origSubject;
    }

    public String getSubject() {
        return subject;
    }

    public String getOrigContent() {
        return origContent;
    }

    public String getOrigRenderedContent() {
        return origRenderedContent;
    }

    public String getContent() {
        return content;
    }

    public String getRenderedContent() {
        return renderedContent;
    }

    public Boolean isMeMessage() {
        return isMeMessage;
    }
}

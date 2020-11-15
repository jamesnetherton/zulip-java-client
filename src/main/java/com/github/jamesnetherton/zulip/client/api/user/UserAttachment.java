package com.github.jamesnetherton.zulip.client.api.user;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;
import java.util.List;

/**
 * Defines a Zulip user attachment.
 */
public class UserAttachment {

    @JsonProperty
    private Instant createTime;

    @JsonProperty
    private long id;

    @JsonProperty
    private List<UserAttachmentMessage> messages;

    @JsonProperty
    private String name;

    @JsonProperty
    private String pathId;

    @JsonProperty
    private long size;

    public Instant getCreateTime() {
        return createTime;
    }

    public long getId() {
        return id;
    }

    public List<UserAttachmentMessage> getMessages() {
        return messages;
    }

    public String getName() {
        return name;
    }

    public String getPathId() {
        return pathId;
    }

    public long getSize() {
        return size;
    }
}

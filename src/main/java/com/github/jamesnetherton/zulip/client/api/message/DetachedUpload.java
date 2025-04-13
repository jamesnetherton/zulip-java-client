package com.github.jamesnetherton.zulip.client.api.message;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

public final class DetachedUpload {
    @JsonProperty
    private int id;
    @JsonProperty
    private String name;
    @JsonProperty
    private String pathId;
    @JsonProperty
    private int size;
    @JsonProperty
    private Instant createTime;
    @JsonProperty
    private List<DetachedUploadMessage> messages = new ArrayList<>();

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getPathId() {
        return pathId;
    }

    public int getSize() {
        return size;
    }

    public Instant getCreateTime() {
        return createTime;
    }

    public List<DetachedUploadMessage> getMessages() {
        return messages;
    }

    public static final class DetachedUploadMessage {
        @JsonProperty
        private int id;
        @JsonProperty
        private Instant dateSent;

        public int getId() {
            return id;
        }

        public Instant getDateSent() {
            return dateSent;
        }
    }
}

package com.github.jamesnetherton.zulip.client.api.draft;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * Defines a Zulip draft
 */
public class Draft {

    @JsonProperty
    @JsonInclude(value = JsonInclude.Include.NON_DEFAULT)
    private long id;

    @JsonProperty
    @JsonSerialize(using = ToStringSerializer.class)
    private DraftType type;

    @JsonProperty
    private List<Long> to = new ArrayList<>();

    @JsonProperty
    private String topic = "";

    @JsonProperty
    private String content;

    @JsonProperty
    private Instant timestamp;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public DraftType getType() {
        return type;
    }

    public void setType(DraftType type) {
        this.type = type;
    }

    public List<Long> getTo() {
        return to;
    }

    public void setTo(List<Long> to) {
        this.to = to;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Instant getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Instant timestamp) {
        this.timestamp = timestamp;
    }
}

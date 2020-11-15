package com.github.jamesnetherton.zulip.client.api.stream;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.Objects;

/**
 * Defines a Zulip stream subscription setting.
 */
public class StreamSubscriptionSetting {

    @JsonProperty
    private long streamId;

    @JsonProperty
    private String property;

    @JsonProperty
    private Object value;

    public StreamSubscriptionSetting() {
    }

    public StreamSubscriptionSetting(long streamId, String property, Object value) {
        this.streamId = streamId;
        this.property = property;
        this.value = value;
    }

    public long getStreamId() {
        return streamId;
    }

    public String getProperty() {
        return property;
    }

    public Object getValue() {
        return value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (o == null || getClass() != o.getClass())
            return false;
        StreamSubscriptionSetting settings = (StreamSubscriptionSetting) o;
        return streamId == settings.streamId &&
                Objects.equals(property, settings.property);
    }

    @Override
    public int hashCode() {
        return Objects.hash(streamId, property);
    }
}

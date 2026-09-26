package com.github.jamesnetherton.zulip.client.api.event;

import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Defines a Zulip event.
 */
public class Event {

    @JsonProperty
    private long id;

    @JsonProperty
    private String type;

    private final Map<String, Object> properties = new LinkedHashMap<>();

    public long getId() {
        return id;
    }

    public String getType() {
        return type;
    }

    /**
     * Gets the event properties that are not mapped to a dedicated field of this class. For event types that have no
     * dedicated {@link Event} subclass, this contains the full event payload other than the id and type.
     *
     * @return Map of event property names to values
     */
    public Map<String, Object> getProperties() {
        return properties;
    }

    @JsonAnySetter
    void setProperty(String name, Object value) {
        properties.put(name, value);
    }
}

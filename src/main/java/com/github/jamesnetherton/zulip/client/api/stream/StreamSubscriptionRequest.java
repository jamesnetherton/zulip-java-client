package com.github.jamesnetherton.zulip.client.api.stream;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Defines a Zulip stream subscription request.
 */
public class StreamSubscriptionRequest {

    @JsonProperty
    private String name;

    @JsonProperty
    private String description;

    /**
     * Constructs a {@link StreamSubscriptionRequest}.
     *
     * @param name        The name of the stream
     * @param description The stream description
     */
    public StreamSubscriptionRequest(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Creates a {@link StreamSubscriptionRequest}.
     *
     * @param  name        The name of the stream
     * @param  description The stream description
     * @return             A new {@link StreamSubscriptionRequest}
     */
    public static StreamSubscriptionRequest of(String name, String description) {
        return new StreamSubscriptionRequest(name, description);
    }
}

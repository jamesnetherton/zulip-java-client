package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for unsubscribing from a stream.
 */
public class UnsubscribeStreamsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<String> notRemoved = new ArrayList<>();

    @JsonProperty
    private List<String> removed = new ArrayList<>();

    public List<String> getNotRemoved() {
        return notRemoved;
    }

    public List<String> getRemoved() {
        return removed;
    }
}

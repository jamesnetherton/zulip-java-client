package com.github.jamesnetherton.zulip.client.api.event.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;
import tools.jackson.databind.JsonNode;

/**
 * Zulip API response class for receiving events from an event queue.
 *
 * @see <a href="https://zulip.com/api/get-events#response">https://zulip.com/api/get-events#response</a>
 */
public class GetEventsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<JsonNode> events = new ArrayList<>();

    public List<JsonNode> getEvents() {
        return events;
    }
}

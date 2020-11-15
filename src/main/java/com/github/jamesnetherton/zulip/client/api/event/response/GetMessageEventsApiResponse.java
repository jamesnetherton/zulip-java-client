package com.github.jamesnetherton.zulip.client.api.event.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.event.MessageEvent;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for receiving a {@link MessageEvent}.
 *
 * @see <a href="https://zulip.com/api/get-events#response">https://zulip.com/api/get-events#response</a>
 */

public class GetMessageEventsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<MessageEvent> events = new ArrayList<>();

    public List<MessageEvent> getMessageEvents() {
        return events;
    }
}

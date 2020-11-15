package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Zulip API response class for subscribing to streams.
 *
 * @see <a href="https://zulip.com/api/subscribe#response">https://zulip.com/api/subscribe#response</a>
 */
public class SubscribeStreamsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private Map<String, List<String>> subscribed = new HashMap<>();

    @JsonProperty
    private Map<String, List<String>> alreadySubscribed = new HashMap<>();

    @JsonProperty
    private List<String> unauthorized = new ArrayList<>();

    public Map<String, List<String>> getSubscribed() {
        return subscribed;
    }

    public Map<String, List<String>> getAlreadySubscribed() {
        return alreadySubscribed;
    }

    public List<String> getUnauthorized() {
        return unauthorized;
    }
}

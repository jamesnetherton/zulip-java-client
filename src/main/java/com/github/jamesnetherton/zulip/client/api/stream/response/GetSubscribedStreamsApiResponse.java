package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscription;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting subscribed streams.
 *
 * @see <a href="https://zulip.com/api/get-subscriptions#response">https://zulip.com/api/get-subscriptions#response</a>
 */
public class GetSubscribedStreamsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<StreamSubscription> subscriptions = new ArrayList<>();

    public List<StreamSubscription> getSubscriptions() {
        return subscriptions;
    }
}

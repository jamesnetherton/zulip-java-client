package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all users subscribed to a stream.
 *
 * @see <a href="https://zulip.com/api/get-subscribers#response">https://zulip.com/api/get-subscribers#response</a>
 */
public class GetStreamSubscribersApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Long> subscribers = new ArrayList<>();

    public List<Long> getSubscribers() {
        return subscribers;
    }
}

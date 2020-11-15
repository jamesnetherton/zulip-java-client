package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for getting a stream subscription status.
 *
 * @see <a href=
 *      "https://zulip.com/api/get-subscription-status#response">https://zulip.com/api/get-subscription-status#response</a>
 */
public class GetSubscriptionStatusApiResponse extends ZulipApiResponse {

    @JsonProperty
    private boolean isSubscribed;

    public boolean isSubscribed() {
        return isSubscribed;
    }
}

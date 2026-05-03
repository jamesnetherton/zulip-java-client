package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting a user's subscribed channels.
 *
 * @see <a href="https://zulip.com/api/get-user-channels">https://zulip.com/api/get-user-channels</a>
 */
public class GetUserChannelsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Long> subscribedChannelIds = new ArrayList<>();

    public List<Long> getSubscribedChannelIds() {
        return subscribedChannelIds;
    }
}

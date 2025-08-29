package com.github.jamesnetherton.zulip.client.api.channel.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response for creating a channel.
 *
 * @see <a href="https://zulip.com/api/create-channel#response">https://zulip.com/api/create-channel#response</a>
 */
public class CreateChannelApiResponse extends ZulipApiResponse {
    @JsonProperty
    private long id;

    public long getId() {
        return id;
    }
}

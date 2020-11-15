package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for sending a message.
 *
 * @see <a href="https://zulip.com/api/send-message#response">https://zulip.com/api/send-message#response</a>
 */
public class SendMessageApiResponse extends ZulipApiResponse {

    @JsonProperty
    private long id;

    public long getId() {
        return id;
    }
}

package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for sending a scheduled message.
 *
 * @see <a href=
 *      "https://zulip.com/api/create-scheduled-message#response">https://zulip.com/api/create-scheduled-message#response</a>
 */
public class SendScheduledMessageApiResponse extends ZulipApiResponse {

    @JsonProperty
    private long scheduledMessageId;

    public long getScheduledMessageId() {
        return scheduledMessageId;
    }
}

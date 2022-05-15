package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.Message;

/**
 * Zulip API response class for getting the raw content from a message.
 *
 * @see <a href="https://zulip.com/api/get-message#response">https://zulip.com/api/get-message#response</a>
 */
public class GetMessageApiResponse extends ZulipApiResponse {

    @JsonProperty
    private Message message;

    @JsonProperty
    private String rawContent;

    public Message getMessage() {
        return message;
    }

    @Deprecated
    public String getRawContent() {
        return rawContent;
    }
}

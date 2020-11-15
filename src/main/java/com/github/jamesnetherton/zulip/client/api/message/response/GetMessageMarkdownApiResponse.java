package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for getting the raw content from a message.
 *
 * @see <a href="https://zulip.com/api/get-raw-message#response">https://zulip.com/api/get-raw-message#response</a>
 */
public class GetMessageMarkdownApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String rawContent;

    public String getRawContent() {
        return rawContent;
    }
}

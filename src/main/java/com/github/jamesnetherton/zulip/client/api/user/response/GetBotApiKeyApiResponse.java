package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for getting a bot's API key.
 *
 * @see <a href="https://zulip.com/api/get-bot-api-key">https://zulip.com/api/get-bot-api-key</a>
 */
public class GetBotApiKeyApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String apiKey;

    public String getApiKey() {
        return apiKey;
    }
}

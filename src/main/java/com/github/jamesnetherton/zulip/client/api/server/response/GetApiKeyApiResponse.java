package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for getting a user API key.
 *
 * @see <a href="https://zulip.com/api/fetch-api-key#response">https://zulip.com/api/fetch-api-key#response</a>
 * @see <a href="https://zulip.com/api/dev-fetch-api-key#response">https://zulip.com/api/dev-fetch-api-key#response</a>
 */
public class GetApiKeyApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String apiKey;

    public String getApiKey() {
        return apiKey;
    }
}

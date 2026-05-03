package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for regenerating an API key.
 *
 * @see <a href="https://zulip.com/api/regenerate-api-key">https://zulip.com/api/regenerate-api-key</a>
 */
public class RegenerateApiKeyApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String apiKey;

    public String getApiKey() {
        return apiKey;
    }
}

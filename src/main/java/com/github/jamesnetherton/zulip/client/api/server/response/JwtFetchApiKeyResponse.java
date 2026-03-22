package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.response.UserApiResponse;

/**
 * Zulip API response class for fetching an API key via JWT.
 *
 * @see <a href="https://zulip.com/api/jwt-fetch-api-key#response">https://zulip.com/api/jwt-fetch-api-key#response</a>
 */
public class JwtFetchApiKeyResponse extends ZulipApiResponse {
    @JsonProperty("api_key")
    private String apiKey;

    @JsonProperty
    private String email;

    @JsonProperty
    private UserApiResponse user;

    public String getApiKey() {
        return apiKey;
    }

    public String getEmail() {
        return email;
    }

    public UserApiResponse getUser() {
        return user;
    }
}

package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for getting a user.
 *
 * @see <a href="https://zulip.com/api/get-user#response">https://zulip.com/api/get-user#response</a>
 */
public class GetUserApiResponse extends ZulipApiResponse {

    @JsonProperty
    private UserApiResponse user;

    public UserApiResponse getUserApiResponse() {
        return user;
    }
}

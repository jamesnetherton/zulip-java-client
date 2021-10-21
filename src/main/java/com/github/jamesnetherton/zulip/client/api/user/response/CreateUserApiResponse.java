package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for creating a new user.
 *
 * @see <a href="https://zulip.com/api/create-user#response">https://zulip.com/api/create-user#response</a>
 */
public class CreateUserApiResponse extends ZulipApiResponse {

    @JsonProperty
    private Long userId;

    public Long getUserId() {
        return userId;
    }
}

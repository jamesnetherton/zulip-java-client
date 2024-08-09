package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserStatus;

/**
 * Zulip API response class for getting a user status.
 *
 * @see <a href="https://zulip.com/api/get-user-status#response">https://zulip.com/api/get-user-status#response</a>
 */
public class GetUserStatusApiResponse extends ZulipApiResponse {
    @JsonProperty
    private UserStatus status;

    public UserStatus getStatus() {
        return status;
    }
}

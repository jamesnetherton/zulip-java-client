package com.github.jamesnetherton.zulip.client.api.user.response;

import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for creating a new user.
 *
 * @see <a href="https://zulip.com/api/create-user#response">https://zulip.com/api/create-user#response</a>
 */
public class CreateUserApiResponse extends ZulipApiResponse {

    // Zulip 4 feature
    //@JsonProperty
    //private Long userId;
    //
    //public Long getUserId() {
    //    return userId;
    //}
}

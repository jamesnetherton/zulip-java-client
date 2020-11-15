package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for creating a custom profile field.
 *
 * @see <a href=
 *      "https://zulip.com/api/create-custom-profile-field#response">https://zulip.com/api/create-custom-profile-field#response</a>
 */
public class CreateProfileFieldApiResponse extends ZulipApiResponse {

    @JsonProperty
    private long id;

    public long getId() {
        return id;
    }
}

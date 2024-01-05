package com.github.jamesnetherton.zulip.client.api.stream.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for getting a stream email address.
 *
 * @see <a href=
 *      "https://zulip.com/api/get-stream-email-address#response">https://zulip.com/api/get-stream-email-address#response</a>
 */
public class GetStreamEmailAddressApiResponse extends ZulipApiResponse {
    @JsonProperty
    private String email;

    public String getEmail() {
        return email;
    }
}

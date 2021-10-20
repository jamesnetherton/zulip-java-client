package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for adding a code playground.
 *
 * @see <a href="https://zulip.com/api/add-code-playground#response">https://zulip.com/api/add-code-playground#response</a>
 */
public class AddCodePlaygroundApiResponse extends ZulipApiResponse {

    @JsonProperty
    private long id;

    public long getId() {
        return id;
    }
}

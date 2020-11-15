package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for adding a linkifier.
 *
 * @see <a href="https://zulip.com/api/add-linkifier#response">https://zulip.com/api/add-linkifier#response</a>
 */
public class AddLinkifierApiResponse extends ZulipApiResponse {

    @JsonProperty
    private Long id;

    public Long getId() {
        return id;
    }
}

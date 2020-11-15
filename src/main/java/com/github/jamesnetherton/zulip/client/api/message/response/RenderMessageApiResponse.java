package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for rendering message to HTML.
 *
 * @see <a href="https://zulip.com/api/render-message#response">https://zulip.com/api/render-message#response</a>
 */
public class RenderMessageApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String rendered;

    public String getRendered() {
        return rendered;
    }
}

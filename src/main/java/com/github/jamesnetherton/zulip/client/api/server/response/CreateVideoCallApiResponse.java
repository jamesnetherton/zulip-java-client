package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for video call creation endpoints.
 */
public class CreateVideoCallApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String url;

    public String getUrl() {
        return url;
    }
}

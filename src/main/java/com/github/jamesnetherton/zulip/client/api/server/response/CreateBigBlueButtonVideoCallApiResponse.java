package com.github.jamesnetherton.zulip.client.api.server.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for creating a BigBlueButton video call.
 *
 * @see <a href=
 *      "https://zulip.com/api/create-big-blue-button-video-call#response">https://zulip.com/api/create-big-blue-button-video-call#response</a>
 */
public class CreateBigBlueButtonVideoCallApiResponse extends ZulipApiResponse {
    @JsonProperty
    private String url;

    public String getUrl() {
        return url;
    }
}

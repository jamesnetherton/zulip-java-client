package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for getting a temporary URL for an uploaded file.
 *
 * @see <a href="https://zulip.com/api/get-file-temporary-url">https://zulip.com/api/get-file-temporary-url</a>
 */
public class GetFileTemporaryUrlApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String url;

    public String getUrl() {
        return url;
    }
}

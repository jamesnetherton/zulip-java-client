package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for uploading a file to the Zulip server.
 *
 * @see <a href="https://zulip.com/api/get-message-history#response">https://zulip.com/api/get-message-history#response</a>
 */
public class FileUploadApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String url;

    public String getUrl() {
        return url;
    }
}

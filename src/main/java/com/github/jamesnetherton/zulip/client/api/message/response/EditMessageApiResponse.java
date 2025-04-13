package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.message.DetachedUpload;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for editing a message.
 *
 * @see <a href="https://zulip.com/api/update-message#response">https://zulip.com/api/update-message#response</a>
 */
public class EditMessageApiResponse extends ZulipApiResponse {
    @JsonProperty
    private List<DetachedUpload> detachedUploads = new ArrayList<>();

    public List<DetachedUpload> getDetachedUploads() {
        return detachedUploads;
    }
}

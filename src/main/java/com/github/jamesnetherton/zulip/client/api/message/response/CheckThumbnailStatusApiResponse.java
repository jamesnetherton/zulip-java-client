package com.github.jamesnetherton.zulip.client.api.message.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for checking whether a thumbnail exists for a user-uploaded file.
 *
 * @see <a href="https://zulip.com/api/check-thumbnail-status">https://zulip.com/api/check-thumbnail-status</a>
 */
public class CheckThumbnailStatusApiResponse extends ZulipApiResponse {

    @JsonProperty
    private boolean hasThumbnail;

    public boolean isHasThumbnail() {
        return hasThumbnail;
    }
}

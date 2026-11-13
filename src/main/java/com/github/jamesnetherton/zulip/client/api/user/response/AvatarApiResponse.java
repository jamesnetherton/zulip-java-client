package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for uploading or deleting the user avatar.
 *
 * @see <a href="https://zulip.com/api/upload-avatar#response">https://zulip.com/api/upload-avatar#response</a>
 */
public class AvatarApiResponse extends ZulipApiResponse {

    @JsonProperty
    private String avatarUrl;

    public String getAvatarUrl() {
        return avatarUrl;
    }
}

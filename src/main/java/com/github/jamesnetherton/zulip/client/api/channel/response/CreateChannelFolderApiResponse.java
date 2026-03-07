package com.github.jamesnetherton.zulip.client.api.channel.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response for creating new channel folder.
 *
 * @see <a href="https://zulip.com/api/create-channel-folder#response">https://zulip.com/api/create-channel-folder#response</a>
 */
public class CreateChannelFolderApiResponse extends ZulipApiResponse {
    @JsonProperty
    private long channelFolderId;

    public long getChannelFolderId() {
        return channelFolderId;
    }
}

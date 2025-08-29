package com.github.jamesnetherton.zulip.client.api.channel.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.channel.ChannelFolder;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response for getting all channel folders.
 *
 * @see <a href="https://zulip.com/api/get-channel-folders#response">https://zulip.com/api/get-channel-folders#response</a>
 */
public class GetChannelFoldersApiResponse extends ZulipApiResponse {
    @JsonProperty
    private List<ChannelFolder> channelFolders = new ArrayList<>();

    public List<ChannelFolder> getChannelFolders() {
        return channelFolders;
    }
}

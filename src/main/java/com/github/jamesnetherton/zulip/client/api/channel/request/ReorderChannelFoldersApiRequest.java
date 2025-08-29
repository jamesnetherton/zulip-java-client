package com.github.jamesnetherton.zulip.client.api.channel.request;

import static com.github.jamesnetherton.zulip.client.api.channel.request.ChannelRequestConstants.CHANNEL_FOLDERS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting all channel folders.
 *
 * @see <a href="https://zulip.com/api/patch-channel-folders">https://zulip.com/api/patch-channel-folders</a>
 */
public class ReorderChannelFoldersApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String ORDER = "order";

    /**
     * Constructs a {@link ReorderChannelFoldersApiRequest}.
     *
     * @param client               The Zulip HTTP client
     * @param channelFolderIdOrder The order of the channel folder ids
     */
    public ReorderChannelFoldersApiRequest(ZulipHttpClient client, Integer... channelFolderIdOrder) {
        super(client);
        putParamAsJsonString(ORDER, channelFolderIdOrder);
    }

    /**
     * Executes the Zulip API request for reordering channel folders.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().patch(CHANNEL_FOLDERS, getParams(), ZulipApiResponse.class);
    }
}

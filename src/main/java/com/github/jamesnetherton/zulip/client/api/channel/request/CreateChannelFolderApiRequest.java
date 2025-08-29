package com.github.jamesnetherton.zulip.client.api.channel.request;

import static com.github.jamesnetherton.zulip.client.api.channel.request.ChannelRequestConstants.CREATE_CHANNEL_FOLDERS;

import com.github.jamesnetherton.zulip.client.api.channel.response.CreateChannelFolderApiResponse;
import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating new channel folder.
 *
 * @see <a href="https://zulip.com/api/create-channel-folder">https://zulip.com/api/create-channel-folder</a>
 */
public class CreateChannelFolderApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Integer> {
    public static final String NAME = "name";
    public static final String DESCRIPTION = "description";

    /**
     * Constructs a {@link CreateChannelFolderApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param name   The name of the channel folder
     */
    public CreateChannelFolderApiRequest(ZulipHttpClient client, String name) {
        super(client);
        putParam(NAME, name);
    }

    /**
     * Sets the description of the channel folder.
     *
     * @see                <a href=
     *                     "https://zulip.com/api/create-channel-folder#parameter-description">https://zulip.com/api/create-channel-folder#parameter-description</a>
     *
     * @param  description The description for the channel folder
     * @return             This {@link CreateChannelFolderApiRequest} instance
     */
    public CreateChannelFolderApiRequest withDescription(String description) {
        putParam(DESCRIPTION, description);
        return this;
    }

    /**
     * Executes the Zulip API request for creating a channel folder.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Integer execute() throws ZulipClientException {
        return client().post(CREATE_CHANNEL_FOLDERS, getParams(), CreateChannelFolderApiResponse.class).getChannelFolderId();
    }
}

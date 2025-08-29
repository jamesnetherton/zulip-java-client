package com.github.jamesnetherton.zulip.client.api.channel.request;

import static com.github.jamesnetherton.zulip.client.api.channel.request.ChannelRequestConstants.CHANNEL_FOLDERS;

import com.github.jamesnetherton.zulip.client.api.channel.ChannelFolder;
import com.github.jamesnetherton.zulip.client.api.channel.response.GetChannelFoldersApiResponse;
import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all channel folders.
 *
 * @see <a href="https://zulip.com/api/get-channel-folders">https://zulip.com/api/get-channel-folders</a>
 */
public class GetChannelFoldersApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<ChannelFolder>> {
    public static final String INCLUDE_ARCHIVED = "include_archived";

    /**
     * Constructs a {@link GetChannelFoldersApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetChannelFoldersApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets whether to include archived channel folders.
     *
     * @param  includeArchived {@code true} to include archived channel folders. {@code false} to exclude them.
     * @return                 This {@link GetChannelFoldersApiRequest} instance
     */
    public GetChannelFoldersApiRequest withIncludeArchived(boolean includeArchived) {
        putParam(INCLUDE_ARCHIVED, includeArchived);
        return this;
    }

    /**
     * Executes the Zulip API request for getting all channel folders.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<ChannelFolder> execute() throws ZulipClientException {
        return client().get(CHANNEL_FOLDERS, getParams(), GetChannelFoldersApiResponse.class).getChannelFolders();
    }
}

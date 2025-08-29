package com.github.jamesnetherton.zulip.client.api.channel.request;

import static com.github.jamesnetherton.zulip.client.api.channel.request.ChannelRequestConstants.CHANNEL_FOLDERS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating a channel folder.
 *
 * @see <a href="https://zulip.com/api/update-channel-folder">https://zulip.com/api/update-channel-folder</a>
 */
public class UpdateChannelFolderApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String NAME = "name";
    public static final String DESCRIPTION = "description";
    public static final String IS_ARCHIVED = "is_archived";

    private final int channelFolderId;

    /**
     * Constructs a {@link UpdateChannelFolderApiRequest}.
     *
     * @param client          The Zulip HTTP client
     * @param channelFolderId The id of the channel folder to update
     */
    public UpdateChannelFolderApiRequest(ZulipHttpClient client, int channelFolderId) {
        super(client);
        this.channelFolderId = channelFolderId;
    }

    /**
     * Sets the updated name of the channel folder.
     *
     * @param  name The updated channel folder name
     * @return      This {@link UpdateChannelFolderApiRequest} instance
     */
    public UpdateChannelFolderApiRequest withName(String name) {
        putParam(NAME, name);
        return this;
    }

    /**
     * Sets the updated description of the channel folder.
     *
     * @param  description The updated channel folder name
     * @return             This {@link UpdateChannelFolderApiRequest} instance
     */
    public UpdateChannelFolderApiRequest withDescription(String description) {
        putParam(DESCRIPTION, description);
        return this;
    }

    /**
     * Sets the updated archived status of the channel folder.
     *
     * @param  isArchived {@code true} to archive the channel folder. {@code false to unarchive} the channel folder
     * @return            This {@link UpdateChannelFolderApiRequest} instance
     */
    public UpdateChannelFolderApiRequest withIsArchived(boolean isArchived) {
        putParam(IS_ARCHIVED, isArchived);
        return this;
    }

    /**
     * Executes the Zulip API request for updating a channel folder.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(CHANNEL_FOLDERS_WITH_ID, this.channelFolderId);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}

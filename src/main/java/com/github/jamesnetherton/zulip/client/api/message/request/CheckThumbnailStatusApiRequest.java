package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.THUMBNAIL_STATUS_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.response.CheckThumbnailStatusApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for checking whether a thumbnail exists for a user-uploaded file.
 *
 * @see <a href="https://zulip.com/api/check-thumbnail-status">https://zulip.com/api/check-thumbnail-status</a>
 */
public class CheckThumbnailStatusApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Boolean> {

    private final String realmIdStr;
    private final String filename;

    /**
     * Constructs a {@link CheckThumbnailStatusApiRequest}.
     *
     * @param client     The Zulip HTTP client
     * @param realmIdStr The realm ID component of the file's {@code path_id}
     * @param filename   The file path component of the file's {@code path_id} (everything after the first {@code /})
     */
    public CheckThumbnailStatusApiRequest(ZulipHttpClient client, String realmIdStr, String filename) {
        super(client);
        this.realmIdStr = realmIdStr;
        this.filename = filename;
    }

    /**
     * Executes the Zulip API request for checking whether a thumbnail exists for a user-uploaded file.
     *
     * @return                      {@code true} if a thumbnail exists for the file, {@code false} otherwise
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Boolean execute() throws ZulipClientException {
        String path = String.format(THUMBNAIL_STATUS_API_PATH, realmIdStr, filename);
        CheckThumbnailStatusApiResponse response = client().get(path, getParams(), CheckThumbnailStatusApiResponse.class);
        return response.isHasThumbnail();
    }
}

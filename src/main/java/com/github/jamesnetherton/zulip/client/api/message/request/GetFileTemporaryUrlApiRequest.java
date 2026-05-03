package com.github.jamesnetherton.zulip.client.api.message.request;

import static com.github.jamesnetherton.zulip.client.api.message.request.MessageRequestConstants.USER_UPLOADS_TEMPORARY_URL_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.message.response.GetFileTemporaryUrlApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting a temporary URL for access to an uploaded file without authentication.
 *
 * @see <a href="https://zulip.com/api/get-file-temporary-url">https://zulip.com/api/get-file-temporary-url</a>
 */
public class GetFileTemporaryUrlApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    private final String realmIdStr;
    private final String filename;

    /**
     * Constructs a {@link GetFileTemporaryUrlApiRequest}.
     *
     * @param client     The Zulip HTTP client
     * @param realmIdStr The realm ID component of the file's {@code path_id}
     * @param filename   The file path component of the file's {@code path_id} (everything after the first {@code /})
     */
    public GetFileTemporaryUrlApiRequest(ZulipHttpClient client, String realmIdStr, String filename) {
        super(client);
        this.realmIdStr = realmIdStr;
        this.filename = filename;
    }

    /**
     * Executes the Zulip API request for getting a temporary URL for an uploaded file.
     *
     * @return                      A temporary URL that provides unauthenticated access to the file
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        String path = String.format(USER_UPLOADS_TEMPORARY_URL_API_PATH, realmIdStr, filename);
        return client().get(path, getParams(), GetFileTemporaryUrlApiResponse.class).getUrl();
    }
}

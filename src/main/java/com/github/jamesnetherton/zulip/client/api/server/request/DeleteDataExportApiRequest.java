package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.EXPORT_REALM_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a data export.
 *
 * @see <a href="https://zulip.com/api/delete-realm-export">https://zulip.com/api/delete-realm-export</a>
 */
public class DeleteDataExportApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long exportId;

    /**
     * Constructs a {@link DeleteDataExportApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param exportId The id of the data export to delete
     */
    public DeleteDataExportApiRequest(ZulipHttpClient client, long exportId) {
        super(client);
        this.exportId = exportId;
    }

    /**
     * Executes the Zulip API request for deleting a data export.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(String.format(EXPORT_REALM_WITH_ID, exportId), getParams(), ZulipApiResponse.class);
    }
}

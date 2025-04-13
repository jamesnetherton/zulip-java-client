package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.EXPORT_REALM;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.DataExport;
import com.github.jamesnetherton.zulip.client.api.server.response.GetAllDataExportsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all data exports.
 *
 * @see <a href="https://zulip.com/api/get-realm-exports">https://zulip.com/api/get-realm-exports</a>
 */
public class GetAllDataExportsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<DataExport>> {
    /**
     * Constructs a {@link GetAllDataExportsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetAllDataExportsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all data exports.
     *
     * @return                      List of {@link DataExport}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<DataExport> execute() throws ZulipClientException {
        return client().get(EXPORT_REALM, getParams(), GetAllDataExportsApiResponse.class).getExports();
    }
}

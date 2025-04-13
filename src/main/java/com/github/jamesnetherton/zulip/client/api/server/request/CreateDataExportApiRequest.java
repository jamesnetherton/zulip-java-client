package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.EXPORT_REALM;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.DataExport;
import com.github.jamesnetherton.zulip.client.api.server.DataExportType;
import com.github.jamesnetherton.zulip.client.api.server.response.CreateDataExportApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a data export.
 *
 * @see <a href="https://zulip.com/api/export-realm">https://zulip.com/api/export-realm</a>
 */
public class CreateDataExportApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Integer> {
    public static final String EXPORT_TYPE = "export_type";

    /**
     * Constructs a {@link CreateDataExportApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public CreateDataExportApiRequest(ZulipHttpClient client) {
        super(client);
        putParam(EXPORT_TYPE, DataExportType.PUBLIC.getId());
    }

    /**
     * Sets the type of the data export.
     *
     * @param  exportType The type of data export
     * @return            This {@link CreateDataExportApiRequest} instance
     */
    public CreateDataExportApiRequest withExportType(DataExportType exportType) {
        putParam(EXPORT_TYPE, exportType.getId());
        return this;
    }

    /**
     * Executes the Zulip API request for creating a data export.
     *
     * @return                      The id of the created {@link DataExport}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Integer execute() throws ZulipClientException {
        return client().post(EXPORT_REALM, getParams(), CreateDataExportApiResponse.class).getId();
    }
}

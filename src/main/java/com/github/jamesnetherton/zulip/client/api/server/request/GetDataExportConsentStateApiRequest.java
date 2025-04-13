package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.EXPORT_REALM_CONSENTS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.DataExportConsent;
import com.github.jamesnetherton.zulip.client.api.server.response.GetDataExportConsentStateApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting users that have consented to their private data being exported.
 *
 * @see <a href="https://zulip.com/api/get-realm-exports">https://zulip.com/api/get-realm-exports</a>
 */
public class GetDataExportConsentStateApiRequest extends ZulipApiRequest
        implements ExecutableApiRequest<List<DataExportConsent>> {
    /**
     * Constructs a {@link GetDataExportConsentStateApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetDataExportConsentStateApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting users that have consented to their private data being exported.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<DataExportConsent> execute() throws ZulipClientException {
        return client().get(EXPORT_REALM_CONSENTS, getParams(), GetDataExportConsentStateApiResponse.class).getExportConsents();
    }
}

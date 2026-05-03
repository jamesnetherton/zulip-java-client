package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_DOMAINS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.RealmDomain;
import com.github.jamesnetherton.zulip.client.api.server.response.GetRealmDomainsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting the allowed email domains configured in the organization.
 *
 * @see <a href="https://zulip.com/api/get-realm-domains">https://zulip.com/api/get-realm-domains</a>
 */
public class GetRealmDomainsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<RealmDomain>> {

    /**
     * Constructs a {@link GetRealmDomainsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetRealmDomainsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting realm allowed domains.
     *
     * @return                      List of {@link RealmDomain} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<RealmDomain> execute() throws ZulipClientException {
        return client().get(REALM_DOMAINS, getParams(), GetRealmDomainsApiResponse.class).getDomains();
    }
}

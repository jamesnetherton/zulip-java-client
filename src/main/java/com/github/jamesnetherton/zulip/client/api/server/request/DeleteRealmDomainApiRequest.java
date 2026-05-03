package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_DOMAINS_WITH_DOMAIN;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for removing an allowed domain from the organization.
 *
 * @see <a href="https://zulip.com/api/remove-realm-domain">https://zulip.com/api/remove-realm-domain</a>
 */
public class DeleteRealmDomainApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final String domain;

    /**
     * Constructs a {@link DeleteRealmDomainApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param domain The domain to remove
     */
    public DeleteRealmDomainApiRequest(ZulipHttpClient client, String domain) {
        super(client);
        this.domain = domain;
    }

    /**
     * Executes the Zulip API request for deleting a realm domain.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(REALM_DOMAINS_WITH_DOMAIN, domain);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}

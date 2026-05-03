package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_DOMAINS_WITH_DOMAIN;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating whether subdomains are allowed for a realm domain.
 *
 * @see <a href="https://zulip.com/api/patch-realm-domain">https://zulip.com/api/patch-realm-domain</a>
 */
public class UpdateRealmDomainApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String ALLOW_SUBDOMAINS = "allow_subdomains";

    private final String domain;

    /**
     * Constructs an {@link UpdateRealmDomainApiRequest}.
     *
     * @param client          The Zulip HTTP client
     * @param domain          The domain to update
     * @param allowSubdomains Whether subdomains are allowed for this domain
     */
    public UpdateRealmDomainApiRequest(ZulipHttpClient client, String domain, boolean allowSubdomains) {
        super(client);
        this.domain = domain;
        putParam(ALLOW_SUBDOMAINS, allowSubdomains);
    }

    /**
     * Executes the Zulip API request for updating a realm domain.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(REALM_DOMAINS_WITH_DOMAIN, domain);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}

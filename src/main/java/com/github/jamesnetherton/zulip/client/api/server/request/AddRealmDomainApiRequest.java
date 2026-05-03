package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_DOMAINS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for adding an allowed domain to the organization.
 *
 * @see <a href="https://zulip.com/api/add-realm-domain">https://zulip.com/api/add-realm-domain</a>
 */
public class AddRealmDomainApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String DOMAIN = "domain";
    public static final String ALLOW_SUBDOMAINS = "allow_subdomains";

    /**
     * Constructs an {@link AddRealmDomainApiRequest}.
     *
     * @param client          The Zulip HTTP client
     * @param domain          The domain to add
     * @param allowSubdomains Whether subdomains are allowed for this domain
     */
    public AddRealmDomainApiRequest(ZulipHttpClient client, String domain, boolean allowSubdomains) {
        super(client);
        putParam(DOMAIN, domain);
        putParam(ALLOW_SUBDOMAINS, allowSubdomains);
    }

    /**
     * Executes the Zulip API request for adding a realm allowed domain.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(REALM_DOMAINS, getParams(), ZulipApiResponse.class);
    }
}

package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_FILTERS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.Linkifier;
import com.github.jamesnetherton.zulip.client.api.server.response.GetLinkifiersApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Collections;
import java.util.List;

/**
 * Zulip API request builder for getting all linkifiers.
 *
 * @see <a href="https://zulip.com/api/get-linkifiers">https://zulip.com/api/get-linkifiers</a>
 */
public class GetLinkifiersApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Linkifier>> {

    /**
     * Constructs a {@link GetLinkifiersApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetLinkifiersApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all linkifiers.
     *
     * @return                      List of {@link Linkifier} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Linkifier> execute() throws ZulipClientException {
        GetLinkifiersApiResponse response = client().get(REALM_FILTERS, getParams(), GetLinkifiersApiResponse.class);
        List<List<Linkifier>> filters = response.getFilters();
        if (filters.isEmpty()) {
            return Collections.emptyList();
        }
        return filters.get(0);
    }
}

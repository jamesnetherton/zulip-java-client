package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_LINKIFIERS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for reordering linkifiers.
 *
 * @see <a href="https://zulip.com/api/reorder-linkifiers">https://zulip.com/api/reorder-linkifiers</a>
 */
public class ReorderLinkifiersApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String ORDERED_LINKIFIER_IDS = "ordered_linkifier_ids";

    /**
     * Constructs a {@link ReorderLinkifiersApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param order  The array of linkifier ids representing their order
     */
    public ReorderLinkifiersApiRequest(ZulipHttpClient client, long... order) {
        super(client);
        putParamAsJsonString(ORDERED_LINKIFIER_IDS, order);
    }

    /**
     * Executes the Zulip API request for reordering linkifiers.
     *
     * @throws ZulipClientException
     */
    @Override
    public void execute() throws ZulipClientException {
        client().patch(REALM_LINKIFIERS, getParams(), ZulipApiResponse.class);
    }
}

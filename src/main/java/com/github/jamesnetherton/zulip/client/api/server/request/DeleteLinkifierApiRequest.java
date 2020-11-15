package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_FILTERS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a linkifier.
 *
 * @see <a href="https://zulip.com/api/remove-linkifier">https://zulip.com/api/remove-linkifier</a>
 */
public class DeleteLinkifierApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long id;

    /**
     * Constructs a {@link DeleteLinkifierApiRequest}.
     * 
     * @param client The Zulip HTTP client
     * @param id     The id of the linkifier to delete
     */
    public DeleteLinkifierApiRequest(ZulipHttpClient client, long id) {
        super(client);
        this.id = id;
    }

    /**
     * Executes the Zulip API request for deleting a linkifier.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(REALM_FILTERS_WITH_ID, id);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}

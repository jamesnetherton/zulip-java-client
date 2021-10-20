package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.REALM_PLAYGROUNDS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for removing a code playground.
 *
 * @see <a href="https://zulip.com/api/remove-code-playground">https://zulip.com/api/remove-code-playground</a>
 */
public class RemoveCodePlaygroundApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final String path;

    /**
     * Constructs a {@link RemoveCodePlaygroundApiRequest}.
     *
     * @param client           The Zulip HTTP client
     * @param codePlaygroundId The id of the code playground to remove
     */
    public RemoveCodePlaygroundApiRequest(ZulipHttpClient client, long codePlaygroundId) {
        super(client);
        this.path = String.format(REALM_PLAYGROUNDS_WITH_ID, codePlaygroundId);
    }

    /**
     * Executes the Zulip API request for removing a code playground.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}

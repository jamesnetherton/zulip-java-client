package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ME;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deactivating the currently logged in user.
 *
 * @see <a href="https://zulip.com/api/deactivate-own-user">https://zulip.com/api/deactivate-own-user</a>
 */
public class DeactivateOwnUserApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    /**
     * Constructs a {@link DeactivateOwnUserApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public DeactivateOwnUserApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for deactivating the currently logged in user.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(USERS_WITH_ME, getParams(), ZulipApiResponse.class);
    }
}

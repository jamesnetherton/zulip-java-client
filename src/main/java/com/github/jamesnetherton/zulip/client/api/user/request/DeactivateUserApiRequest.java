package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deactivating a user.
 *
 * @see <a href="https://zulip.com/api/deactivate-user">https://zulip.com/api/deactivate-user</a>
 */
public class DeactivateUserApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long userId;

    /**
     * Constructs a {@link DeactivateUserApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param userId The id of the user to deactivate
     */
    public DeactivateUserApiRequest(ZulipHttpClient client, long userId) {
        super(client);
        this.userId = userId;
    }

    /**
     * Executes the Zulip API request for deactivating a user.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(USERS_WITH_ID, userId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}

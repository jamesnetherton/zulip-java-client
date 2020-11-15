package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_REACTIVATE;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for reactivating a user.
 *
 * @see <a href="https://zulip.com/api/reactivate-user">https://zulip.com/api/reactivate-user</a>
 */
public class ReactivateUserApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long userId;

    /**
     * Constructs a {@link ReactivateUserApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param userId The user id to reactivate
     */
    public ReactivateUserApiRequest(ZulipHttpClient client, long userId) {
        super(client);
        this.userId = userId;
    }

    /**
     * Executes the Zulip API request for reactivating a user.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(USERS_REACTIVATE, userId);
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}

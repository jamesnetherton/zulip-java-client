package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_MUTED_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for unmuting a user.
 *
 * @see <a href="https://zulip.com/api/unmute-user">https://zulip.com/api/unmute-user</a>
 */
public class UnmuteUserApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final String path;

    /**
     * Constructs a {@link UnmuteUserApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param userId The ID of the user to unmute
     */
    public UnmuteUserApiRequest(ZulipHttpClient client, long userId) {
        super(client);
        this.path = String.format(USERS_MUTED_WITH_ID, userId);
    }

    /**
     * Executes the Zulip API request for unmuting a user.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}

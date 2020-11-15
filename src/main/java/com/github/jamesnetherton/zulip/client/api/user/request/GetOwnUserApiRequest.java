package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ME;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.User;
import com.github.jamesnetherton.zulip.client.api.user.response.UserApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting information about the user who invoked this endpoint.
 *
 * @see <a href="https://zulip.com/api/get-own-user">https://zulip.com/api/get-own-user</a>
 */
public class GetOwnUserApiRequest extends ZulipApiRequest implements ExecutableApiRequest<User> {

    /**
     * Constructs a {@link GetOwnUserApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetOwnUserApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting information about the user who invoked this endpoint.
     *
     * @return                      {@link User} contining information about the user who invoked this endpoint
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public User execute() throws ZulipClientException {
        UserApiResponse response = client().get(USERS_WITH_ME, getParams(), UserApiResponse.class);
        return new User(response);
    }
}

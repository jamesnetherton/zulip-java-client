package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_STATUS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.UserStatus;
import com.github.jamesnetherton.zulip.client.api.user.response.GetUserStatusApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting a user status.
 *
 * @see <a href="https://zulip.com/api/get-user-status">https://zulip.com/api/get-user-status</a>
 */
public class GetUserStatusApiRequest extends ZulipApiRequest implements ExecutableApiRequest<UserStatus> {

    private final String path;

    /**
     * Constructs a {@link GetUserStatusApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param userId The ID of the user to fetch the status for
     */
    public GetUserStatusApiRequest(ZulipHttpClient client, long userId) {
        super(client);
        this.path = String.format(USERS_STATUS, userId);
    }

    /**
     * Executes the Zulip API request for getting a user status.
     *
     * @return                      {@link UserStatus} representing the status of the user
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public UserStatus execute() throws ZulipClientException {
        return client().get(this.path, getParams(), GetUserStatusApiResponse.class).getStatus();
    }
}

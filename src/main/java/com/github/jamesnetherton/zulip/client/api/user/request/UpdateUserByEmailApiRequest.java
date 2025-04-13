package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_EMAIL;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder to update a user by their email address.
 *
 * @see <a href="https://zulip.com/api/update-user-by-email">https://zulip.com/api/update-user-by-email</a>
 */
public class UpdateUserByEmailApiRequest extends UpdateUserApiRequest implements VoidExecutableApiRequest {
    private final String email;

    /**
     * Constructs a {@link UpdateUserByEmailApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param email  The email address of the user to update
     */
    public UpdateUserByEmailApiRequest(ZulipHttpClient client, String email) {
        super(client, 0);
        this.email = email;
    }

    /**
     * Executes the Zulip API request for updating a user by email.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        addProfileDataToParams();
        String path = String.format(USERS_WITH_EMAIL, email);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}

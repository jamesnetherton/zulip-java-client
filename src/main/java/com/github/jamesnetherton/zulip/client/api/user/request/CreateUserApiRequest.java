package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.CreateUserApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a new user.
 *
 * @see <a href="https://zulip.com/api/create-user">https://zulip.com/api/create-user</a>
 */
public class CreateUserApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Long> {

    public static final String EMAIL = "email";
    public static final String FULL_NAME = "full_name";
    public static final String PASSWORD = "password";

    /**
     * Constructs a {@link CreateUserApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param email    The email address of the new user
     * @param fullName The name of the new user
     * @param password The password of the new user
     */
    public CreateUserApiRequest(ZulipHttpClient client, String email, String fullName, String password) {
        super(client);
        putParam(EMAIL, email);
        putParam(FULL_NAME, fullName);
        putParam(PASSWORD, password);
    }

    /**
     * Executes the Zulip API request for creating a new user.
     *
     * @return                      The id of the new user
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Long execute() throws ZulipClientException {
        return client().post(USERS, getParams(), CreateUserApiResponse.class).getUserId();
    }
}

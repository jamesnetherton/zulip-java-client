package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.User;
import com.github.jamesnetherton.zulip.client.api.user.response.GetAllUsersApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API request builder for getting all users.
 *
 * @see <a href="https://zulip.com/api/get-users">https://zulip.com/api/get-users</a>
 */
public class GetAllUsersApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<User>> {

    public static final String CLIENT_GRAVATAR = "client_gravatar";
    public static final String INCLUDE_CUSTOM_PROFILE_FIELDS = "include_custom_profile_fields";
    public static final String USER_IDS = "user_ids";

    /**
     * Constructs a {@link GetAllUsersApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetAllUsersApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets whether to include the user gravatar image URL in the response.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/get-users#parameter-client_gravatar">https://zulip.com/api/get-users#parameter-client_gravatar</a>
     *
     * @param  gravatar {@code true} to include the gravatar image URL in the response. {@code false} to not include the
     *                  gravatar image URL in the response
     * @return          This {@link GetAllUsersApiRequest} instance
     */
    public GetAllUsersApiRequest withClientGravatar(boolean gravatar) {
        putParam(CLIENT_GRAVATAR, gravatar);
        return this;
    }

    /**
     * Sets whether to include the user custom profile fields in the response.
     *
     * @see                               <a href=
     *                                    "https://zulip.com/api/get-users#parameter-include_custom_profile_fields">https://zulip.com/api/get-users#parameter-include_custom_profile_fields</a>
     *
     * @param  includeCustomProfileFields {@code true} to include user custom profile fields in the response. {@code false} to
     *                                    not include user custom profile fields in the response
     * @return                            This {@link GetAllUsersApiRequest} instance
     */
    public GetAllUsersApiRequest withIncludeCustomProfileFields(boolean includeCustomProfileFields) {
        putParam(INCLUDE_CUSTOM_PROFILE_FIELDS, includeCustomProfileFields);
        return this;
    }

    /**
     * Limits the response to users in the given list.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/get-users#parameter-user_ids">https://zulip.com/api/get-users#parameter-user_ids</a>
     *
     * @param  userIds The user ids to limit the response to
     * @return         This {@link GetAllUsersApiRequest} instance
     */
    public GetAllUsersApiRequest withUserIds(Long... userIds) {
        putParamAsJsonString(USER_IDS, userIds);
        return this;
    }

    /**
     * Executes the Zulip API request for getting all users.
     *
     * @return                      List of {@link User} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<User> execute() throws ZulipClientException {
        List<User> users = new ArrayList<>();
        GetAllUsersApiResponse response = client().get(USERS, getParams(), GetAllUsersApiResponse.class);
        response.getMembers()
                .stream()
                .map(User::new)
                .forEach(users::add);
        return users;
    }
}

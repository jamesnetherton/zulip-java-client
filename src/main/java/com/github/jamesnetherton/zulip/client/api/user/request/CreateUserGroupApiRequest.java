package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_CREATE;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a user to a group.
 *
 * @see <a href="https://zulip.com/api/create-user-group">https://zulip.com/api/create-user-group</a>
 */
public class CreateUserGroupApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String NAME = "name";
    public static final String DESCRIPTION = "description";
    public static final String MEMBERS = "members";

    /**
     * Constructs a {@link CreateUserGroupApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param name        The name of the user group
     * @param description The user group description
     * @param userIds     Array of user ids to add to the group
     */
    public CreateUserGroupApiRequest(ZulipHttpClient client, String name, String description, long... userIds) {
        super(client);
        putParam(NAME, name);
        putParam(DESCRIPTION, description);
        putParamAsJsonString(MEMBERS, userIds);
    }

    /**
     * Executes the Zulip API request for adding creating a user group.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(USER_GROUPS_CREATE, getParams(), ZulipApiResponse.class);
    }
}

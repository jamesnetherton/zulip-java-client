package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for updating a user group.
 *
 * @see <a href="https://zulip.com/api/update-user-group">https://zulip.com/api/update-user-group</a>
 */
public class UpdateUserGroupApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String NAME = "name";
    public static final String DESCRIPTION = "description";

    private final long groupId;

    /**
     * Constructs a {@link UpdateUserGroupApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param name        The updated name of the user group
     * @param description The updated description of the user group
     * @param groupId     The id of the group to update
     */
    public UpdateUserGroupApiRequest(ZulipHttpClient client, String name, String description, long groupId) {
        super(client);
        this.groupId = groupId;
        putParam(NAME, name);
        putParam(DESCRIPTION, description);
    }

    /**
     * Executes the Zulip API request for updating a user group.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(USER_GROUPS_WITH_ID, groupId);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}

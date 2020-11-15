package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_MEMBERS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for removing users from a group.
 *
 * @see <a href="https://zulip.com/api/update-user-group-members">https://zulip.com/api/update-user-group-members</a>
 */
public class RemoveUsersFromGroupApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String DELETE = "delete";

    private final long groupId;

    /**
     * Constructs a {@link RemoveUsersFromGroupApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param groupId The id of the group to remove users from
     * @param userIds Array of user ids to remove from the group
     */
    public RemoveUsersFromGroupApiRequest(ZulipHttpClient client, long groupId, long... userIds) {
        super(client);
        this.groupId = groupId;
        putParamAsJsonString(DELETE, userIds);
    }

    /**
     * Executes the Zulip API request for removing users to a group.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(USER_GROUPS_MEMBERS, groupId);
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}

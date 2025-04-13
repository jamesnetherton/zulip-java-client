package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_MEMBERS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for adding users to a group.
 *
 * @see <a href="https://zulip.com/api/update-user-group-members">https://zulip.com/api/update-user-group-members</a>
 */
public class AddUsersToGroupApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String ADD = "add";
    public static final String ADD_SUBGROUPS = "add_subgroups";

    private final long groupId;

    /**
     * Constructs a {@link AddUsersToGroupApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param groupId The id of the group to add users to
     * @param userIds Array of user ids to add to the group
     */
    public AddUsersToGroupApiRequest(ZulipHttpClient client, long groupId, long... userIds) {
        super(client);
        this.groupId = groupId;
        putParamAsJsonString(ADD, userIds);
    }

    /**
     * Sets the list of user group IDs to be added to the user group.
     *
     * @param  userGroupIds The user group IDs to be added to the user group
     * @return              This {@link AddUsersToGroupApiRequest} instance
     */
    public AddUsersToGroupApiRequest withAddSubGroups(long... userGroupIds) {
        putParamAsJsonString(ADD_SUBGROUPS, userGroupIds);
        return this;
    }

    /**
     * Executes the Zulip API request for adding users to a group.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(USER_GROUPS_MEMBERS, groupId);
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}

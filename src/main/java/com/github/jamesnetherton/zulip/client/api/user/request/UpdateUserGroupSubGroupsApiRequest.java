package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_SUBGROUPS;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for updating user group sub groups.
 *
 * @see <a href="https://zulip.com/api/update-user-group-subgroups">https://zulip.com/api/update-user-group-subgroups</a>
 */
public class UpdateUserGroupSubGroupsApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String ADD = "add";
    public static final String DELETE = "delete";
    private final String path;

    /**
     * Constructs a {@link UpdateUserGroupSubGroupsApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param userGroupId The ID of the user group to update
     */
    public UpdateUserGroupSubGroupsApiRequest(ZulipHttpClient client, long userGroupId) {
        super(client);
        this.path = String.format(USER_GROUPS_SUBGROUPS, userGroupId);
    }

    /**
     * The list of user group IDs to be added to the user group.
     *
     * @param  userGroupIds The list of user group IDs to be added to the user group
     * @return              This {@link UpdateUserGroupSubGroupsApiRequest} instance
     */
    public UpdateUserGroupSubGroupsApiRequest withAddUserGroups(List<Long> userGroupIds) {
        putParamAsJsonString(ADD, userGroupIds);
        return this;
    }

    /**
     * The list of user group IDs to be removed from the user group.
     *
     * @param  userGroupIds The list of user group IDs to be removed from the user group
     * @return              This {@link UpdateUserGroupSubGroupsApiRequest} instance
     */
    public UpdateUserGroupSubGroupsApiRequest withDeleteUserGroups(List<Long> userGroupIds) {
        putParamAsJsonString(DELETE, userGroupIds);
        return this;
    }

    /**
     * Executes the Zulip API request for updating user group sub groups.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}

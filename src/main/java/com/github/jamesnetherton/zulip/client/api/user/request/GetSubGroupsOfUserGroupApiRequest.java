package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_SUBGROUPS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.GetSubGroupsOfUserGroupApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Get the subgroups of a user group.
 *
 * @see <a href="https://zulip.com/api/get-user-group-subgroups">https://zulip.com/api/get-user-group-subgroups</a>
 */
public class GetSubGroupsOfUserGroupApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Long>> {

    public static final String DIRECT_SUBGROUP_ONLY = "direct_subgroup_only";
    private final String path;

    /**
     * Constructs a {@link GetSubGroupsOfUserGroupApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param userGroupId The ID of the user group
     */
    public GetSubGroupsOfUserGroupApiRequest(ZulipHttpClient client, long userGroupId) {
        super(client);
        this.path = String.format(USER_GROUPS_SUBGROUPS, userGroupId);
    }

    /**
     * Sets whether to consider only direct subgroups of the user group or subgroups of subgroups.
     *
     * @param  isDirectSubGroupOnly Whether to consider only direct subgroups of the user group or subgroups of subgroups
     * @return                      This {@link GetSubGroupsOfUserGroupApiRequest} instance
     */
    public GetSubGroupsOfUserGroupApiRequest withDirectSubGroupOnly(boolean isDirectSubGroupOnly) {
        putParam(DIRECT_SUBGROUP_ONLY, isDirectSubGroupOnly);
        return this;
    }

    /**
     * Executes the Zulip API request for updating user group sub groups.
     *
     * @return                      the list containing the IDs of subgroups for the user group
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Long> execute() throws ZulipClientException {
        GetSubGroupsOfUserGroupApiResponse response = client().get(path, getParams(), GetSubGroupsOfUserGroupApiResponse.class);
        return response.getSubGroups();
    }
}

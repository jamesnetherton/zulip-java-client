package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_MEMBERS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.GetUserGroupMembersApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting the members of a user group.
 *
 * @see <a href="https://zulip.com/api/get-user-group-members">https://zulip.com/api/get-user-group-members</a>
 */
public class GetUserGroupMembersApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Long>> {

    public static final String DIRECT_MEMBER_ONLY = "direct_member_only";
    private final String path;

    /**
     * Constructs a {@link GetUserGroupMembersApiRequest}.
     *
     * @param userGroupId The id of the user group from which to get members
     * @param client      The Zulip HTTP client
     */
    public GetUserGroupMembersApiRequest(ZulipHttpClient client, long userGroupId) {
        super(client);
        this.path = String.format(USER_GROUPS_MEMBERS, userGroupId);
    }

    /**
     * Sets Whether to consider only the direct members of user group and not members of its subgroups.
     *
     * @param  isDirectMemberOnly {@code true} to consider only direct members of the user group. {@code false} to not consider
     *                            direct members of the user group
     * @return                    This {@link GetUserGroupMembersApiRequest} instance
     */
    public GetUserGroupMembersApiRequest withDirectMemberOnly(boolean isDirectMemberOnly) {
        putParam(DIRECT_MEMBER_ONLY, isDirectMemberOnly);
        return this;
    }

    /**
     * Executes the Zulip API request for getting members of a user group.
     *
     * @return                      The user IDs for the members of the user group
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Long> execute() throws ZulipClientException {
        GetUserGroupMembersApiResponse response = client().get(path, getParams(), GetUserGroupMembersApiResponse.class);
        return response.getMembers();
    }
}

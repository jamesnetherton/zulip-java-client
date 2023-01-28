package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_MEMBERS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.GetUserGroupMembershipStatusApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Check whether a user is member of user group.
 *
 * @see <a href="https://zulip.com/api/get-is-user-group-member">https://zulip.com/api/get-is-user-group-member</a>
 */
public class GetUserGroupMembershipStatusApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Boolean> {

    public static final String DIRECT_MEMBER_ONLY = "direct_member_only";
    private final String path;

    /**
     * Constructs a {@link GetUserGroupMembershipStatusApiRequest}.
     *
     * @param userGroupId The id of the user group
     * @param userId      The id of the user
     * @param client      The Zulip HTTP client
     */
    public GetUserGroupMembershipStatusApiRequest(ZulipHttpClient client, long userGroupId, long userId) {
        super(client);
        this.path = String.format(USER_GROUPS_MEMBERS_WITH_ID, userGroupId, userId);
    }

    /**
     * Sets Whether to consider only the direct members of user group.
     *
     * @param  isDirectMemberOnly {@code true} to consider only direct members of the user group. {@code false} to not consider
     *                            direct members of the user group
     * @return                    This {@link GetUserGroupMembershipStatusApiRequest} instance
     */
    public GetUserGroupMembershipStatusApiRequest withDirectMemberOnly(boolean isDirectMemberOnly) {
        putParam(DIRECT_MEMBER_ONLY, isDirectMemberOnly);
        return this;
    }

    /**
     * Executes the Zulip API request for getting members of a user group.
     *
     * @return                      Whether the user is a member of the specified group
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Boolean execute() throws ZulipClientException {
        GetUserGroupMembershipStatusApiResponse response = client().get(path, getParams(),
                GetUserGroupMembershipStatusApiResponse.class);
        return response.isUserGroupMember();
    }
}

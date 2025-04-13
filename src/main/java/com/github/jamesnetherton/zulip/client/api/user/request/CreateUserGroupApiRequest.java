package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_CREATE;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserGroupSetting;
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
    public static final String CAN_ADD_MEMBERS_GROUP = "can_add_members_group";
    public static final String CAN_JOIN_GROUP = "can_join_group";
    public static final String CAN_LEAVE_GROUP = "can_leave_group";
    public static final String CAN_MANAGE_GROUP = "can_manage_group";
    public static final String CAN_MENTION_GROUP = "can_mention_group";
    public static final String CAN_REMOVE_MEMBERS_GROUP = "can_remove_members_group";

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
     * Sets the optional ID of the user group whose members are allowed to mention the new user group.
     *
     * @param      groupId The ID of the user group whose members are allowed to mention the new user group
     * @return             This {@link CreateUserGroupApiRequest} instance
     * @deprecated         Use {@link CreateUserGroupApiRequest#withCanMentionGroup(UserGroupSetting)}
     */
    @Deprecated(forRemoval = true)
    public CreateUserGroupApiRequest withCanMentionGroup(long groupId) {
        withCanMentionGroup(UserGroupSetting.of((int) groupId));
        return this;
    }

    /**
     * Sets the users who have permission to mention this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to mention this group
     * @return                  This {@link CreateUserGroupApiRequest} instance
     */
    public CreateUserGroupApiRequest withCanMentionGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_MENTION_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to add members to this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to add members to this group
     * @return                  This {@link CreateUserGroupApiRequest} instance
     */
    public CreateUserGroupApiRequest withCanAddMembersGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_ADD_MEMBERS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to join this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to join this group
     * @return                  This {@link CreateUserGroupApiRequest} instance
     */

    public CreateUserGroupApiRequest withCanJoinMembersGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_JOIN_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to leave this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to leave this group
     * @return                  This {@link CreateUserGroupApiRequest} instance
     */
    public CreateUserGroupApiRequest withCanLeaveGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_LEAVE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to manage this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to manage this group
     * @return                  This {@link CreateUserGroupApiRequest} instance
     */
    public CreateUserGroupApiRequest withCanManageGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_MANAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to remove members from this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to remove members from this group
     * @return                  This {@link CreateUserGroupApiRequest} instance
     */
    public CreateUserGroupApiRequest withCanRemoveMembersGroup(UserGroupSetting userGroupSetting) {
        putParamAsJsonString(CAN_REMOVE_MEMBERS_GROUP, userGroupSetting);
        return this;
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

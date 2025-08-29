package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserGroupSetting;
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
    public static final String CAN_ADD_MEMBERS_GROUP = "can_add_members_group";
    public static final String CAN_JOIN_GROUP = "can_join_group";
    public static final String CAN_LEAVE_GROUP = "can_leave_group";
    public static final String CAN_MANAGE_GROUP = "can_manage_group";
    public static final String CAN_MENTION_GROUP = "can_mention_group";
    public static final String CAN_REMOVE_MEMBERS_GROUP = "can_remove_members_group";
    public static final String DEACTIVATED = "deactivated";

    private final long groupId;

    /**
     * Constructs a {@link UpdateUserGroupApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param groupId The id of the group to update
     */
    public UpdateUserGroupApiRequest(ZulipHttpClient client, long groupId) {
        super(client);
        this.groupId = groupId;
    }

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
        withName(name);
        withDescription(description);
    }

    /**
     * Sets the updated description of the user group.
     *
     * @param  description The new description of the user group
     * @return             This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withDescription(String description) {
        putParam(DESCRIPTION, description);
        return this;
    }

    /**
     * Sets the updated name of the user group.
     *
     * @param  name The new name of the user group
     * @return      This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withName(String name) {
        putParam(NAME, name);
        return this;
    }

    /**
     * Sets the optional ID of the user group whose members are allowed to mention the new user group.
     *
     * @param      userGroupId The new ID of the user group whose members are allowed to mention the new user group
     * @return                 This {@link UpdateUserGroupApiRequest} instance
     * @deprecated             Use {@link UpdateUserGroupApiRequest#withCanMentionGroup(UserGroupSetting)}
     */
    @Deprecated(forRemoval = true)
    public UpdateUserGroupApiRequest withCanMentionGroup(long userGroupId) {
        withCanMentionGroup(UserGroupSetting.of((int) userGroupId));
        return this;
    }

    /**
     * Sets the users who have permission to mention this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to mention this group
     * @return                  This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withCanMentionGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_MENTION_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to add members to this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to add members to this group
     * @return                  This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withCanAddMembersGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_ADD_MEMBERS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to join this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to join this group
     * @return                  This {@link UpdateUserGroupApiRequest} instance
     */

    public UpdateUserGroupApiRequest withCanJoinMembersGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_JOIN_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to leave this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to leave this group
     * @return                  This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withCanLeaveGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_LEAVE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to manage this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to manage this group
     * @return                  This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withCanManageGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_MANAGE_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Sets the users who have permission to remove members from this group.
     *
     * @param  userGroupSetting The {@link UserGroupSetting} for users who have permission to remove members from this group
     * @return                  This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withCanRemoveMembersGroup(UserGroupSetting userGroupSetting) {
        putParamAsWrappedObject("new", CAN_REMOVE_MEMBERS_GROUP, userGroupSetting);
        return this;
    }

    /**
     * Reactivates a deactivated user group.
     *
     * @return This {@link UpdateUserGroupApiRequest} instance
     */
    public UpdateUserGroupApiRequest withReactivateGroup() {
        putParam(DEACTIVATED, false);
        return this;
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

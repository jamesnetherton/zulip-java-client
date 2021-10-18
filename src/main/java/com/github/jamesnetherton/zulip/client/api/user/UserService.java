package com.github.jamesnetherton.zulip.client.api.user;

import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.user.request.AddUsersToGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.CreateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.CreateUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.DeactivateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.DeleteUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetAllUsersApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetOwnUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserAttachmentsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserGroupsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserPresenceApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.ReactivateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.RemoveUsersFromGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.SetTypingStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip user APIs.
 */
public class UserService implements ZulipService {

    private final ZulipHttpClient client;

    /**
     * Constructs a {@link UserService}.
     *
     * @param client The Zulip HTTP client
     */
    public UserService(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Create a new user.
     *
     * @see             <a href="https://zulip.com/api/create-user">https://zulip.com/api/create-user</a>
     *
     * @param  email    The email address of the new user
     * @param  fullName The name of the new user
     * @param  password The password of the new user
     * @return          The {@link CreateUserApiRequest} builder object
     */
    public CreateUserApiRequest createUser(String email, String fullName, String password) {
        return new CreateUserApiRequest(this.client, email, fullName, password);
    }

    /**
     * Deactivate a user.
     *
     * @see           <a href="https://zulip.com/api/deactivate-user">https://zulip.com/api/deactivate-user</a>
     *
     * @param  userId The id of the user to deactivate
     * @return        The {@link DeactivateUserApiRequest} builder object
     */
    public DeactivateUserApiRequest deactivate(long userId) {
        return new DeactivateUserApiRequest(this.client, userId);
    }

    /**
     * Reactivates a user.
     *
     * @see           <a href="https://zulip.com/api/reactivate-user">https://zulip.com/api/reactivate-user</a>
     *
     * @param  userId The user id to reactivate
     * @return        The {@link ReactivateUserApiRequest} builder object
     */
    public ReactivateUserApiRequest reactivate(long userId) {
        return new ReactivateUserApiRequest(this.client, userId);
    }

    /**
     * Sets user 'typing' status
     *
     * @see              <a href="https://zulip.com/api/set-typing-status">https://zulip.com/api/set-typing-status</a>
     *
     * @param  operation The typing operation to apply
     * @param  userIds   Array of user ids to add to set the typing status for
     * @return           The {@link SetTypingStatusApiRequest} builder object
     */
    public SetTypingStatusApiRequest setTyping(TypingOperation operation, long... userIds) {
        return new SetTypingStatusApiRequest(this.client, operation, userIds);
    }

    /**
     * Create a new user group.
     *
     * @see                <a href="https://zulip.com/api/create-user-group">https://zulip.com/api/create-user-group</a>
     *
     * @param  name        The name of the user group
     * @param  description The user group description
     * @param  userIds     Array of user ids to add to the group
     * @return             The {@link CreateUserGroupApiRequest} builder object
     */
    public CreateUserGroupApiRequest createUserGroup(String name, String description, long... userIds) {
        return new CreateUserGroupApiRequest(this.client, name, description, userIds);
    }

    /**
     * Updates a user group.
     *
     * @see                <a href="https://zulip.com/api/update-user-group">https://zulip.com/api/update-user-group</a>
     *
     * @param  name        The updated name of the user group
     * @param  description The updated description of the user group
     * @param  groupId     The id of the group to update
     * @return             The {@link UpdateUserGroupApiRequest} builder object
     */
    public UpdateUserGroupApiRequest updateUserGroup(String name, String description, long groupId) {
        return new UpdateUserGroupApiRequest(this.client, name, description, groupId);
    }

    /**
     * Deletes a user group.
     *
     * @see            <a href="https://zulip.com/api/remove-user-group">https://zulip.com/api/remove-user-group</a>
     *
     * @param  groupId The id of the group to delete
     * @return         The {@link DeleteUserGroupApiRequest} builder object
     */
    public DeleteUserGroupApiRequest deleteUserGroup(long groupId) {
        return new DeleteUserGroupApiRequest(this.client, groupId);
    }

    /**
     * Add sers to a group.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/update-user-group-members">https://zulip.com/api/update-user-group-members</a>
     *
     * @param  groupId The id of the group to add users to
     * @param  userIds Array of user ids to add to the group
     * @return         The {@link AddUsersToGroupApiRequest} builder object
     */
    public AddUsersToGroupApiRequest addUsersToGroup(long groupId, long... userIds) {
        return new AddUsersToGroupApiRequest(this.client, groupId, userIds);
    }

    /**
     * Remove users from a group.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/update-user-group-members">https://zulip.com/api/update-user-group-members</a>
     *
     * @param  groupId The id of the group to remove users from
     * @param  userIds Array of user ids to remove from the group
     * @return         The {@link RemoveUsersFromGroupApiRequest} builder object
     */
    public RemoveUsersFromGroupApiRequest removeUsersFromGroup(long groupId, long... userIds) {
        return new RemoveUsersFromGroupApiRequest(this.client, groupId, userIds);
    }

    /**
     * Get all user groups.
     *
     * @see    <a href="https://zulip.com/api/get-user-groups">https://zulip.com/api/get-user-groups</a>
     *
     * @return The {@link GetUserGroupsApiRequest} builder object
     */
    public GetUserGroupsApiRequest getUserGroups() {
        return new GetUserGroupsApiRequest(this.client);
    }

    /**
     * Update user notification settings.
     *
     * @see    <a href=
     *         "https://zulip.com/api/update-notification-settings">https://zulip.com/api/update-notification-settings</a>
     *
     * @return The {@link UpdateNotificationSettingsApiRequest} builder object
     */
    public UpdateNotificationSettingsApiRequest updateNotificationSettings() {
        return new UpdateNotificationSettingsApiRequest(this.client);
    }

    /**
     * Get information about the user who invokes this endpoint
     *
     * @see    <a href="https://zulip.com/api/get-own-user">https://zulip.com/api/get-own-user</a>
     *
     * @return The {@link GetOwnUserApiRequest} builder object
     */
    public GetOwnUserApiRequest getOwnUser() {
        return new GetOwnUserApiRequest(this.client);
    }

    /**
     * Gets all users.
     *
     * @see    <a href="https://zulip.com/api/get-users">https://zulip.com/api/get-users</a>
     *
     * @return The {@link GetAllUsersApiRequest} builder object
     */
    public GetAllUsersApiRequest getAllUsers() {
        return new GetAllUsersApiRequest(this.client);
    }

    /**
     * Gets a user by id.
     *
     * @see           <a href="https://zulip.com/api/get-user">https://zulip.com/api/get-user</a>
     *
     * @param  userId The id of the user to get
     * @return        The {@link GetUserApiRequest} builder object
     */
    public GetUserApiRequest getUser(long userId) {
        return new GetUserApiRequest(this.client, userId);
    }

    /**
     * Gets a user by the given Zulip display email address.
     *
     * @see          <a href="https://zulip.com/api/get-user-by-email">https://zulip.com/api/get-user-by-email</a>
     *
     * @param  email The Zulip display email address of the user to get
     * @return       The {@link GetUserApiRequest} builder object
     */
    public GetUserApiRequest getUser(String email) {
        return new GetUserApiRequest(this.client, email);
    }

    /**
     * Update a user.
     *
     * @see           <a href="https://zulip.com/api/update-user">https://zulip.com/api/update-user</a>
     *
     * @param  userId The id of the user to update
     * @return        The {@link UpdateUserApiRequest} builder object
     */
    public UpdateUserApiRequest updateUser(long userId) {
        return new UpdateUserApiRequest(this.client, userId);
    }

    /**
     * Get user presence information.
     *
     * @see          <a href="https://zulip.com/api/get-user-presence">https://zulip.com/api/get-user-presence</a>
     *
     * @param  email The email address of the user to get presence details for
     * @return       The {@link GetUserPresenceApiRequest} builder object
     */
    public GetUserPresenceApiRequest getUserPresence(String email) {
        return new GetUserPresenceApiRequest(this.client, email);
    }

    /**
     * Get user attachments.
     *
     * @see    <a href="https://zulip.com/api/update-user-group-members">https://zulip.com/api/update-user-group-members</a>
     *
     * @return The {@link GetUserAttachmentsApiRequest} builder object
     */
    public GetUserAttachmentsApiRequest getUserAttachments() {
        return new GetUserAttachmentsApiRequest(this.client);
    }
}

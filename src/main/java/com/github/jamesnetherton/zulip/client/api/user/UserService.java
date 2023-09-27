package com.github.jamesnetherton.zulip.client.api.user;

import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.user.request.AddAlertWordsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.AddUsersToGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.CreateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.CreateUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.DeactivateOwnUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.DeactivateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.DeleteUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetAllAlertWordsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetAllUsersApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetOwnUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetSubGroupsOfUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserAttachmentsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserGroupMembersApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserGroupMembershipStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserGroupsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserPresenceApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.MuteUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.ReactivateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.RemoveAlertWordsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.RemoveUsersFromGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.SetTypingStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UnmuteUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateOwnUserSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateOwnUserStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserGroupSubGroupsApiRequest;
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
     * Deactivates the user who invokes this endpoint.
     *
     * @see    <a href="https://zulip.com/api/deactivate-own-user">https://zulip.com/api/deactivate-own-user</a>
     *
     * @return The {@link DeactivateOwnUserApiRequest} builder object
     */
    public DeactivateOwnUserApiRequest deactivateOwnUser() {
        return new DeactivateOwnUserApiRequest(this.client);
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
     * Sets user 'typing' status
     *
     * @see              <a href="https://zulip.com/api/set-typing-status">https://zulip.com/api/set-typing-status</a>
     *
     * @param  operation The typing operation to apply
     * @param  streamId  The id of the stream in which the message is being typed
     * @param  topic     The name of the topic in which the message is being typed
     * @return           The {@link SetTypingStatusApiRequest} builder object
     */
    public SetTypingStatusApiRequest setTyping(TypingOperation operation, long streamId, String topic) {
        return new SetTypingStatusApiRequest(this.client, operation, streamId, topic);
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
     * @see            <a href="https://zulip.com/api/update-user-group">https://zulip.com/api/update-user-group</a>
     *
     * @param  groupId The id of the group to update
     * @return         The {@link UpdateUserGroupApiRequest} builder object
     */
    public UpdateUserGroupApiRequest updateUserGroup(long groupId) {
        return new UpdateUserGroupApiRequest(this.client, groupId);
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
     * Get user group members.
     *
     * @see                <a href=
     *                     "https://zulip.com/api/get-user-group-members">https://zulip.com/api/get-user-group-members</a>
     *
     * @param  userGroupId The id of the user group to fetch members from
     * @return             The {@link GetUserGroupMembersApiRequest} builder object
     */
    public GetUserGroupMembersApiRequest getUserGroupMembers(long userGroupId) {
        return new GetUserGroupMembersApiRequest(this.client, userGroupId);
    }

    /**
     * Check whether a user is member of a user group.
     *
     * @see                <a href=
     *                     "https://zulip.com/api/get-is-user-group-member">https://zulip.com/api/get-is-user-group-member</a>
     *
     * @param  userGroupId The id of the user group on which the user belongs
     * @param  userId      The id of the user
     * @return             The {@link GetUserGroupMembershipStatusApiRequest} builder object
     */
    public GetUserGroupMembershipStatusApiRequest getUserGroupMembershipStatus(long userGroupId, long userId) {
        return new GetUserGroupMembershipStatusApiRequest(this.client, userGroupId, userId);
    }

    /**
     * Update user notification settings.
     *
     * @see    <a href=
     *         "https://zulip.com/api/update-notification-settings">https://zulip.com/api/update-notification-settings</a>
     *
     * @return The {@link UpdateNotificationSettingsApiRequest} builder object
     */
    @Deprecated
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

    /**
     * Mute a user.
     *
     * @see           <a href="https://zulip.com/api/mute-user">https://zulip.com/api/mute-user</a>
     *
     * @param  userId The id of the user to mute
     * @return        The {@link MuteUserApiRequest} builder object
     */
    public MuteUserApiRequest mute(long userId) {
        return new MuteUserApiRequest(this.client, userId);
    }

    /**
     * Updates aspects of the status for the user who invokes this endpoint.
     *
     * @see    <a href="https://zulip.com/api/update-status">https://zulip.com/api/update-status</a>
     *
     * @return The {@link UpdateOwnUserStatusApiRequest} builder object
     */
    public UpdateOwnUserStatusApiRequest updateOwnUserStatus() {
        return new UpdateOwnUserStatusApiRequest(this.client);
    }

    /**
     * Updates settings for the user who invokes this endpoint.
     *
     * @see    <a href="https://zulip.com/api/update-settings">https://zulip.com/api/update-settings</a>
     *
     * @return The {@link UpdateOwnUserSettingsApiRequest} builder object
     */
    public UpdateOwnUserSettingsApiRequest updateOwnUserSettings() {
        return new UpdateOwnUserSettingsApiRequest(this.client);
    }

    /**
     * Unmute a user.
     *
     * @see           <a href="https://zulip.com/api/unmute-user">https://zulip.com/api/unmute-user</a>
     *
     * @param  userId The id of the user to unmute
     * @return        The {@link UnmuteUserApiRequest} builder object
     */
    public UnmuteUserApiRequest unmute(long userId) {
        return new UnmuteUserApiRequest(this.client, userId);
    }

    /**
     * Get the subgroups of a user group.
     *
     * @see                <a href=
     *                     "https://zulip.com/api/get-user-group-subgroups">https://zulip.com/api/get-user-group-subgroups</a>
     *
     * @param  userGroupId The ID of the user group
     * @return             The {@link GetSubGroupsOfUserGroupApiRequest} builder object
     */
    public GetSubGroupsOfUserGroupApiRequest getSubGroupsOfUserGroup(long userGroupId) {
        return new GetSubGroupsOfUserGroupApiRequest(this.client, userGroupId);
    }

    /**
     * Updates user group sub groups.
     *
     * @see                <a href=
     *                     "https://zulip.com/api/update-user-group-subgroups">https://zulip.com/api/update-user-group-subgroups</a>
     *
     * @param  userGroupId The ID of the user group to update
     * @return             The {@link UpdateUserGroupSubGroupsApiRequest} builder object
     */
    public UpdateUserGroupSubGroupsApiRequest updateUserGroupSubGroups(long userGroupId) {
        return new UpdateUserGroupSubGroupsApiRequest(this.client, userGroupId);
    }

    /**
     * Adds user alert words.
     *
     * @see               <a href=
     *                    "https://zulip.com/api/add-alert-words">https://zulip.com/api/add-alert-words</a>
     *
     * @param  alertWords An array of strings, where each string is an alert word (or phrase)
     * @return            The {@link AddAlertWordsApiRequest} builder object
     */
    public AddAlertWordsApiRequest addAlertWords(String... alertWords) {
        return new AddAlertWordsApiRequest(this.client, alertWords);
    }

    /**
     * Gets all user alert words.
     *
     * @see    <a href=
     *         "https://zulip.com/api/get-alert-words">https://zulip.com/api/get-alert-words</a>
     *
     * @return The {@link GetAllAlertWordsApiRequest} builder object
     */
    public GetAllAlertWordsApiRequest getAllAlertWords() {
        return new GetAllAlertWordsApiRequest(this.client);
    }

    /**
     * Removes user alert words.
     *
     * @see               <a href=
     *                    "https://zulip.com/api/remove-alert-words">https://zulip.com/api/remove-alert-words</a>
     *
     * @param  alertWords An array of strings, where each string is an alert word (or phrase)
     * @return            The {@link RemoveAlertWordsApiRequest} builder object
     */
    public RemoveAlertWordsApiRequest removeAlertWords(String... alertWords) {
        return new RemoveAlertWordsApiRequest(this.client, alertWords);
    }
}

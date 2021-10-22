package com.github.jamesnetherton.zulip.client.api.user;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.PATCH;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.user.request.AddUsersToGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.CreateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.CreateUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetAllUsersApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.RemoveUsersFromGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.SetTypingStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.util.JsonUtils;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class ZulipUserApiTest extends ZulipApiTestBase {

    @Test
    public void createUser() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateUserApiRequest.EMAIL, "test@test.com")
                .add(CreateUserApiRequest.FULL_NAME, "Test Tester")
                .add(CreateUserApiRequest.PASSWORD, "abc12345")
                .get();

        stubZulipResponse(POST, "/users", params, "createUser.json");

        long userId = zulip.users().createUser("test@test.com", "Test Tester", "abc12345").execute();
        assertEquals(25, userId);
    }

    @Test
    public void reactivateUser() throws Exception {
        stubZulipResponse(POST, "/users/5/reactivate", Collections.emptyMap());

        zulip.users().reactivate(5).execute();
    }

    @Test
    public void deactivateUser() throws Exception {
        stubZulipResponse(DELETE, "/users/5", Collections.emptyMap());

        zulip.users().deactivate(5).execute();
    }

    @Test
    public void setTyping() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SetTypingStatusApiRequest.OPERATION, TypingOperation.START.toString())
                .add(SetTypingStatusApiRequest.TO, "\\[1,2,3\\]")
                .get();

        stubZulipResponse(POST, "/typing", params);

        zulip.users().setTyping(TypingOperation.START, 1, 2, 3).execute();
    }

    @Test
    public void createUserGroup() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateUserGroupApiRequest.NAME, "Test Group Name")
                .add(CreateUserGroupApiRequest.DESCRIPTION, "Test Group Description")
                .add(CreateUserGroupApiRequest.MEMBERS, "\\[1,2,3\\]")
                .get();

        stubZulipResponse(POST, "/user_groups/create", params);

        zulip.users().createUserGroup("Test Group Name", "Test Group Description", 1, 2, 3).execute();
    }

    @Test
    public void updateUserGroup() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateUserGroupApiRequest.NAME, "New Group Name")
                .add(UpdateUserGroupApiRequest.DESCRIPTION, "New Group Description")
                .get();

        stubZulipResponse(PATCH, "/user_groups/3", params);

        zulip.users().updateUserGroup("New Group Name", "New Group Description", 3).execute();
    }

    @Test
    public void deleteUserGroup() throws Exception {
        stubZulipResponse(DELETE, "/user_groups/7", Collections.emptyMap());

        zulip.users().deleteUserGroup(7).execute();
    }

    @Test
    public void addUsersToGroup() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddUsersToGroupApiRequest.ADD, "\\[1,2,3\\]")
                .get();

        stubZulipResponse(POST, "/user_groups/7/members", params);

        zulip.users().addUsersToGroup(7, 1, 2, 3).execute();
    }

    @Test
    public void removeUsersFromGroup() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(RemoveUsersFromGroupApiRequest.DELETE, "\\[1,2,3\\]")
                .get();

        stubZulipResponse(POST, "/user_groups/7/members", params);

        zulip.users().removeUsersFromGroup(7, 1, 2, 3).execute();
    }

    @Test
    public void getUserGroups() throws Exception {
        stubZulipResponse(GET, "/user_groups", "userGroups.json");

        List<UserGroup> groups = zulip.users().getUserGroups().execute();
        for (int i = 1; i <= groups.size(); i++) {
            UserGroup group = groups.get(i - 1);
            assertEquals(i, group.getId());
            assertEquals("Test Group Description " + i, group.getDescription());
            assertEquals("Test Group Name " + i, group.getName());
            assertArrayEquals(new Long[] { 1L, 2L, 3L }, group.getMembers().toArray(new Long[3]));
        }
    }

    @Test
    public void updateNotificationSettings() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateNotificationSettingsApiRequest.DESKTOP_ICON_COUNT_DISPLAY, "2")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_STREAM_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_STREAM_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_STREAM_PUSH_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_STREAM_AUDIBLE_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.NOTIFICATION_SOUND, "ding")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_SOUNDS, "true")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_OFFLINE_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_OFFLINE_PUSH_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_ONLINE_PUSH_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_DIGEST_EMAILS, "true")
                .add(UpdateNotificationSettingsApiRequest.ENABLE_LOGIN_EMAILS, "true")
                .add(UpdateNotificationSettingsApiRequest.MESSAGE_CONTENT_IN_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.PM_CONTENT_IN_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.WILDCARD_MENTIONS_NOTIFY, "true")
                .add(UpdateNotificationSettingsApiRequest.REALM_NAME_IN_NOTIFICATIONS, "true")
                .add(UpdateNotificationSettingsApiRequest.PRESENCE_ENABLED, "true")
                .get();

        stubZulipResponse(PATCH, "/settings/notifications", params, "updateNotificationSettings.json");

        Map<String, Object> settings = zulip.users().updateNotificationSettings()
                .withEnableOfflinePushNotifications(true)
                .withEnableOnlinePushNotifications(true)
                .withEnableStreamAudibleNotifications(true)
                .withEnableLoginEmails(true)
                .withEnableDigestEmails(true)
                .withEnableDesktopNotifications(true)
                .withEnableOfflineEmailNotifications(true)
                .withEnableSounds(true)
                .withNotificationSound("ding")
                .withPmContentInDesktopNotifications(true)
                .withPresenceEnabled(true)
                .withDesktopIconCountDisplay(DesktopIconCountDisplay.PRIVATE_MESSAGES_AND_MENTIONS)
                .withEnableStreamAudibleNotifications(true)
                .withEnableStreamDesktopNotifications(true)
                .withEnableStreamEmailNotifications(true)
                .withEnableStreamPushNotifications(true)
                .withMessageContentInEmailNotifications(true)
                .withWildcardMentionsNotify(true)
                .withRealmNameInNotifications(true)
                .execute();

        assertEquals(18, settings.size());

        for (String key : settings.keySet()) {
            Object value = settings.get(key);
            if (value instanceof Boolean) {
                assertTrue((Boolean) value);
            } else if (value instanceof String) {
                assertEquals("ding", value);
            } else if (value instanceof DesktopIconCountDisplay) {
                assertEquals(DesktopIconCountDisplay.PRIVATE_MESSAGES_AND_MENTIONS, value);
            } else {
                fail("Unknown type in settings map");
            }
        }

        assertEquals(DesktopIconCountDisplay.UNKNOWN, DesktopIconCountDisplay.fromInt(99));
    }

    @Test
    public void ownUser() throws Exception {
        stubZulipResponse(GET, "/users/me", "getOwnUser.json");

        User user = zulip.users().getOwnUser().execute();

        assertEquals("https://secure.gravatar.com/avatar/af4f06322c177ef4e1e9b2c424986b54?d=identicon&version=1",
                user.getAvatarUrl());
        assertEquals("2019-10-20T07:50:53.728864+00:00", user.getDateJoined());
        assertEquals("foo@bar.com", user.getDeliveryEmail());
        assertEquals("foo@bar.com", user.getEmail());
        assertEquals("Foo Bar", user.getFullName());
        assertEquals("Europe/London", user.getTimezone());
        assertEquals(1, user.getAvatarVersion());
        assertEquals(5, user.getUserId());
        assertTrue(user.isActive());
        assertTrue(user.isAdmin());
        assertFalse(user.isBot());
        assertFalse(user.isGuest());
        assertFalse(user.isOwner());

        Map<String, ProfileData> profileDataMap = user.getProfileData();
        assertEquals(2, profileDataMap.size());

        ProfileData profileDataA = profileDataMap.get("1");
        assertNull(profileDataA.getValue());
        assertEquals("Test Rendered Value 1", profileDataA.getRenderedValue());

        ProfileData profileDataB = profileDataMap.get("2");
        assertEquals("Test Value 2", profileDataB.getValue());
        assertEquals("Test Rendered Value 2", profileDataB.getRenderedValue());
    }

    @Test
    public void allUsers() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetAllUsersApiRequest.CLIENT_GRAVATAR, "true")
                .add(GetAllUsersApiRequest.INCLUDE_CUSTOM_PROFILE_FIELDS, "true")
                .get();

        stubZulipResponse(GET, "/users", params, "getAllUsers.json");

        List<User> users = zulip.users().getAllUsers()
                .withClientGravatar(true)
                .withIncludeCustomProfileFields(true)
                .execute();

        assertEquals(2, users.size());

        for (int i = 1; i <= users.size(); i++) {
            User user = users.get(i - 1);

            assertEquals("https://secure.gravatar.com/avatar/af4f06322c177ef4e1e9b2c424986b54?d=identicon&version=1",
                    user.getAvatarUrl());
            assertEquals("2019-10-20T07:50:53.728864+00:00", user.getDateJoined());
            assertEquals("test" + i + "@test.com", user.getDeliveryEmail());
            assertEquals("test" + i + "@test.com", user.getEmail());
            assertEquals("User " + i, user.getFullName());
            assertEquals("Europe/London", user.getTimezone());
            assertEquals(i, user.getAvatarVersion());
            assertEquals(i, user.getUserId());
            assertTrue(user.isActive());
            assertTrue(user.isAdmin());
            assertFalse(user.isBot());
            assertFalse(user.isGuest());
            assertFalse(user.isOwner());

            Map<String, ProfileData> profileDataMap = user.getProfileData();
            assertEquals(2, profileDataMap.size());

            ProfileData profileDataA = profileDataMap.get("1");
            assertNull(profileDataA.getValue());
            assertEquals("Test Rendered Value 1", profileDataA.getRenderedValue());

            ProfileData profileDataB = profileDataMap.get("2");
            assertEquals("Test Value 2", profileDataB.getValue());
            assertEquals("Test Rendered Value 2", profileDataB.getRenderedValue());
        }
    }

    @Test
    public void getUserById() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetUserApiRequest.CLIENT_GRAVATAR, "true")
                .add(GetUserApiRequest.INCLUDE_CUSTOM_PROFILE_FIELDS, "true")
                .get();

        stubZulipResponse(GET, "/users/1", params, "getUser.json");

        User user = zulip.users().getUser(1)
                .withClientGravatar(true)
                .withIncludeCustomProfileFields(true)
                .execute();

        assertEquals("https://secure.gravatar.com/avatar/af4f06322c177ef4e1e9b2c424986b54?d=identicon&version=1",
                user.getAvatarUrl());
        assertEquals("2019-10-20T07:50:53.728864+00:00", user.getDateJoined());
        assertEquals("foo@bar.com", user.getDeliveryEmail());
        assertEquals("foo@bar.com", user.getEmail());
        assertEquals("Foo Bar", user.getFullName());
        assertEquals("Europe/London", user.getTimezone());
        assertEquals(1, user.getAvatarVersion());
        assertEquals(5, user.getUserId());
        assertTrue(user.isActive());
        assertTrue(user.isAdmin());
        assertFalse(user.isBot());
        assertFalse(user.isGuest());
        assertFalse(user.isOwner());

        Map<String, ProfileData> profileDataMap = user.getProfileData();
        assertEquals(2, profileDataMap.size());

        ProfileData profileDataA = profileDataMap.get("1");
        assertNull(profileDataA.getValue());
        assertEquals("Test Rendered Value 1", profileDataA.getRenderedValue());

        ProfileData profileDataB = profileDataMap.get("2");
        assertEquals("Test Value 2", profileDataB.getValue());
        assertEquals("Test Rendered Value 2", profileDataB.getRenderedValue());
    }

    @Test
    public void getUserByEmail() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetUserApiRequest.CLIENT_GRAVATAR, "true")
                .add(GetUserApiRequest.INCLUDE_CUSTOM_PROFILE_FIELDS, "true")
                .get();

        stubZulipResponse(GET, "/users/test@test.com", params, "getUser.json");

        User user = zulip.users().getUser("test@test.com")
                .withClientGravatar(true)
                .withIncludeCustomProfileFields(true)
                .execute();

        assertEquals("https://secure.gravatar.com/avatar/af4f06322c177ef4e1e9b2c424986b54?d=identicon&version=1",
                user.getAvatarUrl());
        assertEquals("2019-10-20T07:50:53.728864+00:00", user.getDateJoined());
        assertEquals("foo@bar.com", user.getDeliveryEmail());
        assertEquals("foo@bar.com", user.getEmail());
        assertEquals("Foo Bar", user.getFullName());
        assertEquals("Europe/London", user.getTimezone());
        assertEquals(1, user.getAvatarVersion());
        assertEquals(5, user.getUserId());
        assertTrue(user.isActive());
        assertTrue(user.isAdmin());
        assertFalse(user.isBot());
        assertFalse(user.isGuest());
        assertFalse(user.isOwner());

        Map<String, ProfileData> profileDataMap = user.getProfileData();
        assertEquals(2, profileDataMap.size());

        ProfileData profileDataA = profileDataMap.get("1");
        assertNull(profileDataA.getValue());
        assertEquals("Test Rendered Value 1", profileDataA.getRenderedValue());

        ProfileData profileDataB = profileDataMap.get("2");
        assertEquals("Test Value 2", profileDataB.getValue());
        assertEquals("Test Rendered Value 2", profileDataB.getRenderedValue());
    }

    @Test
    public void updateUser() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateUserApiRequest.FULL_NAME, JsonUtils.getMapper().writeValueAsString("Updated User"))
                .add(UpdateUserApiRequest.ROLE, "200")
                .add(UpdateUserApiRequest.PROFILE_DATA, "\\[\\{\"id\":1,\"value\":\"bar\"\\}\\]")
                .get();

        stubZulipResponse(PATCH, "/users/1", params);

        zulip.users().updateUser(1)
                .withFullName("Updated User")
                .withRole(UserRole.ORGANIZATION_ADMIN)
                .withProfileData(1, "bar")
                .execute();
    }

    @Test
    public void userPresence() throws Exception {
        stubZulipResponse(GET, "/users/test@test.com/presence", "getUserPresence.json");

        Map<String, UserPresenceDetail> presence = zulip.users().getUserPresence("test@test.com").execute();
        assertEquals(2, presence.size());

        UserPresenceDetail detailA = presence.get("ZulipMobile");
        assertEquals(1603913066000L, detailA.getTimestamp().toEpochMilli());
        assertEquals(UserPresenceStatus.ACTIVE, detailA.getStatus());

        UserPresenceDetail detailB = presence.get("website");
        assertEquals(1603913066000L, detailB.getTimestamp().toEpochMilli());
        assertEquals(UserPresenceStatus.IDLE, detailB.getStatus());
    }

    @Test
    public void attachments() throws Exception {
        stubZulipResponse(GET, "/attachments", "getUserAttachments.json");

        List<UserAttachment> attachments = zulip.users().getUserAttachments().execute();
        assertEquals(1, attachments.size());

        UserAttachment attachment = attachments.get(0);
        assertEquals("12345.jpg", attachment.getName());
        assertEquals("a/foo/bar/12345.jpg", attachment.getPathId());
        assertEquals(1603913066000L, attachment.getCreateTime().toEpochMilli());
        assertEquals(1, attachment.getId());
        assertEquals(12345, attachment.getSize());
        assertEquals(2, attachment.getMessages().size());

        List<UserAttachmentMessage> messages = attachment.getMessages();
        UserAttachmentMessage messageA = messages.get(0);
        assertEquals(1, messageA.getId());
        assertEquals(1603913066000L, messageA.getDateSent().toEpochMilli());

        UserAttachmentMessage messageB = messages.get(0);
        assertEquals(1, messageB.getId());
        assertEquals(1603913066000L, messageB.getDateSent().toEpochMilli());
    }

    @Test
    public void muteUser() throws Exception {
        stubZulipResponse(POST, "/users/me/muted_users/5", Collections.emptyMap());

        zulip.users().mute(5).execute();
    }

    @Test
    public void unmuteUser() throws Exception {
        stubZulipResponse(DELETE, "/users/me/muted_users/5", Collections.emptyMap());

        zulip.users().unmute(5).execute();
    }
}

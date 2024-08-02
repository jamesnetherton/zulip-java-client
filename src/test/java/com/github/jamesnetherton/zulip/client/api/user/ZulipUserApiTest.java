package com.github.jamesnetherton.zulip.client.api.user;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.PATCH;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.message.MessageType;
import com.github.jamesnetherton.zulip.client.api.message.ReactionType;
import com.github.jamesnetherton.zulip.client.api.server.MarkReadOnScrollPolicy;
import com.github.jamesnetherton.zulip.client.api.server.RealmNameInNotificationsPolicy;
import com.github.jamesnetherton.zulip.client.api.user.request.AddAlertWordsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.AddUsersToGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.CreateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.CreateUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetAllUsersApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetSubGroupsOfUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserGroupMembersApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.GetUserGroupMembershipStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.RemoveUsersFromGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.SetTypingStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateOwnUserSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateOwnUserStatusApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserGroupApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateUserGroupSubGroupsApiRequest;
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
    public void deactivateOwnUser() throws Exception {
        stubZulipResponse(DELETE, "/users/me", Collections.emptyMap());

        zulip.users().deactivateOwnUser().execute();
    }

    @Test
    public void setTyping() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SetTypingStatusApiRequest.OPERATION, TypingOperation.START.toString())
                .add(SetTypingStatusApiRequest.TO, "[1,2,3]")
                .get();

        stubZulipResponse(POST, "/typing", params);

        zulip.users().setTyping(TypingOperation.START, 1, 2, 3).execute();
    }

    @Test
    public void setTypingForStream() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SetTypingStatusApiRequest.OPERATION, TypingOperation.START.toString())
                .add(SetTypingStatusApiRequest.STREAM_ID, "1")
                .add(SetTypingStatusApiRequest.TOPIC, "test typing topic")
                .add(SetTypingStatusApiRequest.TYPE, MessageType.STREAM.toString())
                .get();

        stubZulipResponse(POST, "/typing", params);

        zulip.users().setTyping(TypingOperation.START, 1, "test typing topic").execute();
    }

    @Test
    public void createUserGroup() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateUserGroupApiRequest.NAME, "Test Group Name")
                .add(CreateUserGroupApiRequest.DESCRIPTION, "Test Group Description")
                .add(CreateUserGroupApiRequest.MEMBERS, "[1,2,3]")
                .add(CreateUserGroupApiRequest.CAN_MENTION_GROUP, "1")
                .get();

        stubZulipResponse(POST, "/user_groups/create", params);

        zulip.users().createUserGroup("Test Group Name", "Test Group Description", 1, 2, 3)
                .withCanMentionGroup(1)
                .execute();
    }

    @Test
    public void updateUserGroup() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateUserGroupApiRequest.NAME, "New Group Name")
                .add(UpdateUserGroupApiRequest.DESCRIPTION, "New Group Description")
                .add(UpdateUserGroupApiRequest.CAN_MENTION_GROUP, "1")
                .get();

        stubZulipResponse(PATCH, "/user_groups/3", params);

        zulip.users().updateUserGroup("New Group Name", "New Group Description", 3)
                .withCanMentionGroup(1)
                .execute();
    }

    @Test
    public void updateUserGroupWithNameOrDescription() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .get();

        stubZulipResponse(PATCH, "/user_groups/3", params);

        zulip.users().updateUserGroup(3).execute();
    }

    @Test
    public void deleteUserGroup() throws Exception {
        stubZulipResponse(DELETE, "/user_groups/7", Collections.emptyMap());

        zulip.users().deleteUserGroup(7).execute();
    }

    @Test
    public void addUsersToGroup() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddUsersToGroupApiRequest.ADD, "[1,2,3]")
                .get();

        stubZulipResponse(POST, "/user_groups/7/members", params);

        zulip.users().addUsersToGroup(7, 1, 2, 3).execute();
    }

    @Test
    public void removeUsersFromGroup() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(RemoveUsersFromGroupApiRequest.DELETE, "[1,2,3]")
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
            assertEquals(i == 1 ? true : false, group.isSystemGroup());
            assertEquals(i, group.getCanMentionGroup());

            List<Long> directGroupSubIds = group.getDirectSubgroupIds();
            assertEquals(1, directGroupSubIds.size());
            assertEquals(i, directGroupSubIds.get(0));
        }
    }

    @Test
    public void updateNotificationSettings() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateNotificationSettingsApiRequest.DESKTOP_ICON_COUNT_DISPLAY, "3")
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
                .add(UpdateNotificationSettingsApiRequest.ENABLE_STREAM_DESKTOP_NOTIFICATIONS, "true")
                .get();

        stubZulipResponse(PATCH, "/settings/notifications", params, "updateNotificationSettings.json");

        Map<String, Object> settings = zulip.users().updateNotificationSettings()
                .withEnableOfflinePushNotifications(true)
                .withEnableOnlinePushNotifications(true)
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
        assertTrue(user.isBillingAdmin());
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
            assertTrue(user.isBillingAdmin());
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
        assertTrue(user.isBillingAdmin());
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

        stubZulipResponse(GET, "/users/test%40test.com", params, "getUser.json");

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
        assertTrue(user.isBillingAdmin());
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
                .add(UpdateUserApiRequest.FULL_NAME, "Updated User")
                .add(UpdateUserApiRequest.ROLE, "200")
                .add(UpdateUserApiRequest.PROFILE_DATA, "[{\"id\":1,\"value\":\"bar\"}]")
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
        stubZulipResponse(GET, "/users/test%40test.com/presence", "getUserPresence.json");

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

    @Test
    public void updateOwnUserStatus() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateOwnUserStatusApiRequest.AWAY, "true")
                .add(UpdateOwnUserStatusApiRequest.EMOJI_CODE, "test")
                .add(UpdateOwnUserStatusApiRequest.EMOJI_NAME, "test name")
                .add(UpdateOwnUserStatusApiRequest.REACTION_TYPE, ReactionType.REALM.toString())
                .add(UpdateOwnUserStatusApiRequest.STATUS_TEXT, "test status text")
                .get();

        stubZulipResponse(POST, "/users/me/status", params);

        zulip.users().updateOwnUserStatus()
                .withAway(true)
                .withEmojiCode("test")
                .withEmojiName("test name")
                .withReactionType(ReactionType.REALM)
                .withStatusText("test status text")
                .execute();
    }

    @Test
    public void updateOwnUserSettings() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateOwnUserSettingsApiRequest.COLOR_SCHEME, String.valueOf(ColorScheme.DARK.getId()))
                .add(UpdateOwnUserSettingsApiRequest.DEFAULT_LANGUAGE, "de")
                .add(UpdateOwnUserSettingsApiRequest.DEFAULT_VIEW, WebHomeView.RECENT_TOPICS.toString())
                .add(UpdateOwnUserSettingsApiRequest.DEMOTE_INACTIVE_STREAMS,
                        String.valueOf(DemoteInactiveStreamOption.ALWAYS.getId()))
                .add(UpdateOwnUserSettingsApiRequest.DESKTOP_ICON_COUNT_DISPLAY,
                        String.valueOf(DesktopIconCountDisplay.ALL_UNREADS.getSetting()))
                .add(UpdateOwnUserSettingsApiRequest.DISPLAY_EMOJI_REACTION_USERS, "true")
                .add(UpdateOwnUserSettingsApiRequest.EMAIL, "test@test.com")
                .add(UpdateOwnUserSettingsApiRequest.EMAIL_NOTIFICATIONS_BATCHING_PERIOD_SECONDS, "60")
                .add(UpdateOwnUserSettingsApiRequest.EMOJISET, EmojiSet.TWITTER.toString())
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_DIGEST_EMAILS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_DRAFTS_SYNCHRONIZATION, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_LOGIN_EMAILS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_MARKETING_EMAILS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_OFFLINE_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_OFFLINE_PUSH_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_ONLINE_PUSH_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_SOUNDS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_STREAM_AUDIBLE_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_STREAM_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_STREAM_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENABLE_STREAM_PUSH_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ENTER_SENDS, "true")
                .add(UpdateOwnUserSettingsApiRequest.ESCAPE_NAVIGATES_TO_DEFAULT_VIEW, "true")
                .add(UpdateOwnUserSettingsApiRequest.FLUID_LAYOUT_WIDTH, "true")
                .add(UpdateOwnUserSettingsApiRequest.FULL_NAME, "tester")
                .add(UpdateOwnUserSettingsApiRequest.HIGH_CONTRAST_MODE, "true")
                .add(UpdateOwnUserSettingsApiRequest.LEFT_SIDE_USERLIST, "true")
                .add(UpdateOwnUserSettingsApiRequest.MESSAGE_CONTENT_IN_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.NEW_PASSWORD, "new-password")
                .add(UpdateOwnUserSettingsApiRequest.STARRED_MESSAGE_COUNTS, "true")
                .add(UpdateOwnUserSettingsApiRequest.NOTIFICATION_SOUND, "ding")
                .add(UpdateOwnUserSettingsApiRequest.OLD_PASSWORD, "old-password")
                .add(UpdateOwnUserSettingsApiRequest.PM_CONTENT_IN_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.PRESENCE_ENABLED, "true")
                .add(UpdateOwnUserSettingsApiRequest.REALM_NAME_IN_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.REALM_NAME_IN_EMAIL_NOTIFICATIONS_POLICY, "2")
                .add(UpdateOwnUserSettingsApiRequest.SEND_PRIVATE_TYPING_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.SEND_READ_RECEIPTS, "true")
                .add(UpdateOwnUserSettingsApiRequest.SEND_STREAM_TYPING_NOTIFICATIONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.STARRED_MESSAGE_COUNTS, "true")
                .add(UpdateOwnUserSettingsApiRequest.TIMEZONE, "Europe/London")
                .add(UpdateOwnUserSettingsApiRequest.TRANSLATE_EMOTICONS, "true")
                .add(UpdateOwnUserSettingsApiRequest.TWENTY_FOUR_HOUR_TIME, "true")
                .add(UpdateOwnUserSettingsApiRequest.USER_LIST_STYLE, "2")
                .add(UpdateOwnUserSettingsApiRequest.WEB_MARK_READ_ON_SCROLL_POLICY, "2")
                .add(UpdateOwnUserSettingsApiRequest.WILDCARD_MENTIONS_NOTIFY, "true")
                .get();

        stubZulipResponse(PATCH, "/settings", params, "updateOwnUserSettings.json");

        List<String> result = zulip.users().updateOwnUserSettings()
                .withColorScheme(ColorScheme.DARK)
                .withDefaultLanguage("de")
                .withDefaultView(WebHomeView.RECENT_TOPICS)
                .withDemoteInactiveStreams(DemoteInactiveStreamOption.ALWAYS)
                .withDesktopIconCountDisplay(DesktopIconCountDisplay.ALL_UNREADS)
                .withDisplayEmojiReactionUsers(true)
                .withEmail("test@test.com")
                .withEmailNotificationsBatchingPeriodSeconds(60)
                .withEmojiSet(EmojiSet.TWITTER)
                .withEnableDesktopNotifications(true)
                .withEnableDigestEmails(true)
                .withEnableDraftsSynchronization(true)
                .withEnableLoginEmails(true)
                .withEnableMarketingEmails(true)
                .withEnableOfflineEmailNotifications(true)
                .withEnableOfflinePushNotifications(true)
                .withEnableOnlinePushNotifications(true)
                .withEnableSounds(true)
                .withEnableStreamAudibleNotifications(true)
                .withEnableStreamDesktopNotifications(true)
                .withEnableStreamEmailNotifications(true)
                .withEnableStreamPushNotifications(true)
                .withEnterSends(true)
                .withEscapeNavigatesToDefaultView(true)
                .withFluidLayoutWidth(true)
                .withFullName("tester")
                .withHighContrastMode(true)
                .withLeftSideUserList(true)
                .withMessageContentInEmailNotifications(true)
                .withNewPassword("new-password")
                .withNotificationSound("ding")
                .withOldPassword("old-password")
                .withPmContentInDesktopNotifications(true)
                .withPresenceEnabled(true)
                .withRealmNameInNotifications(true)
                .withRealmNameInEmailNotifications(RealmNameInNotificationsPolicy.ALWAYS)
                .withSendPrivateTypingNotifications(true)
                .withSendReadReceipts(true)
                .withSendStreamTypingNotifications(true)
                .withStarredMessageCounts(true)
                .withTimezone("Europe/London")
                .withTranslateEmoticons(true)
                .withTwentyFourHourTime(true)
                .withUserListStyle(UserListStyle.WITH_STATUS)
                .withWebMarkReadOnScrollPolicy(MarkReadOnScrollPolicy.CONSERVATION_VIEWS)
                .withWildcardMentionsNotify(true)
                .execute();

        assertNotNull(result);
        assertEquals(2, result.size());
        assertEquals("name", result.get(0));
        assertEquals("password", result.get(1));
    }

    @Test
    public void getSubGroupsOfUserGroup() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetSubGroupsOfUserGroupApiRequest.DIRECT_SUBGROUP_ONLY, "true")
                .get();

        stubZulipResponse(GET, "/user_groups/1/subgroups", params, "getSubGroupsOfUserGroup.json");

        List<Long> ids = zulip.users().getSubGroupsOfUserGroup(1)
                .withDirectSubGroupOnly(true)
                .execute();

        assertEquals(List.of(1L, 2L, 3L), ids);
    }

    @Test
    public void updateUserGroupSubGroupsAdd() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateUserGroupSubGroupsApiRequest.ADD, "[1,2,3]")
                .get();

        stubZulipResponse(POST, "/user_groups/1/subgroups", params);

        zulip.users().updateUserGroupSubGroups(1)
                .withAddUserGroups(List.of(1L, 2L, 3L))
                .execute();
    }

    @Test
    public void updateUserGroupSubGroupsDelete() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateUserGroupSubGroupsApiRequest.DELETE, "[1,2,3]")
                .get();

        stubZulipResponse(POST, "/user_groups/1/subgroups", params);

        zulip.users().updateUserGroupSubGroups(1)
                .withDeleteUserGroups(List.of(1L, 2L, 3L))
                .execute();
    }

    @Test
    public void getUserGroupMembers() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetUserGroupMembersApiRequest.DIRECT_MEMBER_ONLY, "true")
                .get();

        stubZulipResponse(GET, "/user_groups/1/members", params, "getUserGroupMembers.json");

        List<Long> members = zulip.users().getUserGroupMembers(1)
                .withDirectMemberOnly(true)
                .execute();

        assertEquals(List.of(1L, 2L, 3L), members);
    }

    @Test
    public void getUserGroupMembershipStatus() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetUserGroupMembershipStatusApiRequest.DIRECT_MEMBER_ONLY, "true")
                .get();

        stubZulipResponse(GET, "/user_groups/1/members/2", params, "getUserGroupMembershipStatus.json");

        boolean isMember = zulip.users().getUserGroupMembershipStatus(1, 2)
                .withDirectMemberOnly(true)
                .execute();

        assertTrue(isMember);
    }

    @Test
    public void addAlertWords() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddAlertWordsApiRequest.ALERT_WORDS, "[\"foo\",\"bar\"]")
                .get();

        stubZulipResponse(POST, "/users/me/alert_words", params, "alertWordsResponse.json");

        List<String> alertWords = zulip.users().addAlertWords("foo", "bar").execute();
        assertEquals(2, alertWords.size());
        assertTrue(alertWords.containsAll(List.of("foo", "bar")));
    }

    @Test
    public void getAllAlertWords() throws Exception {
        stubZulipResponse(GET, "/users/me/alert_words", "alertWordsResponse.json");

        List<String> alertWords = zulip.users().getAllAlertWords().execute();
        assertEquals(2, alertWords.size());
        assertTrue(alertWords.containsAll(List.of("foo", "bar")));
    }

    @Test
    public void removeAlertWords() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddAlertWordsApiRequest.ALERT_WORDS, "[\"foo\"]")
                .get();

        stubZulipResponse(DELETE, "/users/me/alert_words", params, "removeAlertWordsResponse.json");

        List<String> alertWords = zulip.users().removeAlertWords("foo").execute();
        assertEquals(1, alertWords.size());
        assertTrue(alertWords.contains("bar"));
    }
}

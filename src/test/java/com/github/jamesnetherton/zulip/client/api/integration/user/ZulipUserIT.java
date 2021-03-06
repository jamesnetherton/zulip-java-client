package com.github.jamesnetherton.zulip.client.api.integration.user;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.stream.StreamPostPolicy;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionRequest;
import com.github.jamesnetherton.zulip.client.api.user.DesktopIconCountDisplay;
import com.github.jamesnetherton.zulip.client.api.user.TypingOperation;
import com.github.jamesnetherton.zulip.client.api.user.User;
import com.github.jamesnetherton.zulip.client.api.user.UserAttachment;
import com.github.jamesnetherton.zulip.client.api.user.UserAttachmentMessage;
import com.github.jamesnetherton.zulip.client.api.user.UserGroup;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceDetail;
import com.github.jamesnetherton.zulip.client.api.user.UserRole;
import com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Calendar;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.Test;

public class ZulipUserIT extends ZulipIntegrationTestBase {

    @Test
    public void userCrudOperations() throws ZulipClientException {
        Calendar calendar = Calendar.getInstance();
        String id = UUID.randomUUID().toString().split("-")[0];

        // Create user
        zulip.users().createUser(id + "@test.com", id, "T00s3cr3t").execute();

        // This is a zulip 4 feature
        // if (userId != null) {
        //    assertTrue(userId > 0);
        // }

        // Since Zulip 3.x does not return the created user id, use this method to find it
        List<User> users = zulip.users().getAllUsers().execute();
        User createdUser = users.stream()
                .filter(User::isActive)
                .filter(u -> u.getEmail().equals(id + "@test.com"))
                .findFirst()
                .get();
        assertNotNull(createdUser);

        // Retrieve user
        try {
            User user = zulip.users().getUser(createdUser.getUserId()).execute();
            assertTrue(user.getAvatarUrl().startsWith("https://secure.gravatar.com/avatar"));
            assertTrue(user.getDateJoined().startsWith(String.valueOf(calendar.get(Calendar.YEAR))));
            assertEquals(id + "@test.com", user.getEmail());
            assertEquals(id, user.getFullName());
            assertEquals(1, user.getAvatarVersion());
            assertEquals(createdUser.getUserId(), user.getUserId());
            assertTrue(user.isActive());
            assertFalse(user.isAdmin());
            assertFalse(user.isBot());
            assertFalse(user.isGuest());
            assertFalse(user.isOwner());
            assertTrue(user.getProfileData().isEmpty());

            // Update user
            zulip.users().updateUser(createdUser.getUserId())
                    .withRole(UserRole.ORGANIZATION_ADMIN)
                    .withFullName("Edited Name " + id)
                    .execute();

            user = zulip.users().getUser(createdUser.getUserId()).execute();
            assertEquals("Edited Name " + id, user.getFullName());
            assertTrue(user.isAdmin());

            zulip.users().deactivate(createdUser.getUserId()).execute();
        } catch (Throwable t) {
            try {
                zulip.users().deactivate(createdUser.getUserId()).execute();
            } catch (Throwable t2) {
                // Ignore
            }
            throw t;
        }
    }

    @Test
    public void ownUser() throws ZulipClientException {
        User user = zulip.users().getOwnUser().execute();

        assertTrue(user.getAvatarUrl().startsWith("https://secure.gravatar.com/avatar"));
        assertTrue(user.getDateJoined().startsWith("2020"));
        assertEquals("test@test.com", user.getEmail());
        assertEquals("Test Tester", user.getFullName());
        assertEquals("Europe/London", user.getTimezone());
        assertEquals(1, user.getAvatarVersion());
        assertEquals(ownUser.getUserId(), user.getUserId());
        assertTrue(user.isActive());
        assertTrue(user.isAdmin());
        assertFalse(user.isBot());
        assertFalse(user.isGuest());
        assertTrue(user.isOwner());
        assertTrue(user.getProfileData().isEmpty());
    }

    @Test
    public void activateDeactivate() throws ZulipClientException {
        String id = UUID.randomUUID().toString().split("-")[0];

        zulip.users().createUser(id + "@test.com", id, "T00s3cr3t").execute();

        List<User> users = zulip.users().getAllUsers().execute();
        User createdUser = users.stream()
                .filter(User::isActive)
                .filter(u -> u.getEmail().equals(id + "@test.com"))
                .findFirst()
                .get();
        assertNotNull(createdUser);

        // Retrieve user
        try {
            User user = zulip.users().getUser(createdUser.getUserId()).execute();
            assertTrue(user.isActive());

            // Deactivate user
            zulip.users().deactivate(createdUser.getUserId()).execute();
            user = zulip.users().getUser(createdUser.getUserId()).execute();
            assertFalse(user.isActive());

            // Reactivate user
            zulip.users().reactivate(createdUser.getUserId()).execute();
            user = zulip.users().getUser(createdUser.getUserId()).execute();
            assertTrue(user.isActive());

            zulip.users().deactivate(createdUser.getUserId()).execute();
        } catch (Throwable t) {
            try {
                zulip.users().deactivate(createdUser.getUserId()).execute();
            } catch (Throwable t2) {
                // Ignore
            }
            throw t;
        }
    }

    @Test
    public void userAttachments() throws Exception {
        zulip.streams().subscribe(
                StreamSubscriptionRequest.of("File Stream", "File Stream"))
                .withAuthorizationErrorsFatal(false)
                .withHistoryPublicToSubscribers(true)
                .withInviteOnly(false)
                .withStreamPostPolicy(StreamPostPolicy.ANY)
                .execute();

        Path tmpFile = Files.createTempFile("zulip", ".txt");
        Files.write(tmpFile, "test content".getBytes(StandardCharsets.UTF_8));

        File file = tmpFile.toFile();
        String url = zulip.messages().fileUpload(file).execute();

        long messageId = zulip.messages()
                .sendStreamMessage("File " + configuration.getZulipUrl() + url, "File Stream", "File Topic")
                .execute();

        List<UserAttachment> attachments = zulip.users().getUserAttachments().execute();
        assertFalse(attachments.isEmpty());

        Thread.sleep(10000);

        boolean matched = false;
        for (UserAttachment attachment : attachments) {
            if (!attachment.getMessages().isEmpty()) {
                Optional<UserAttachmentMessage> optional = attachment.getMessages().stream()
                        .filter(m -> m.getId() == messageId)
                        .findFirst();

                if (optional.isPresent()) {
                    matched = true;

                    assertEquals(file.getName(), attachment.getName());
                    assertTrue(attachment.getCreateTime().toEpochMilli() > 0);
                    assertTrue(attachment.getId() > 0);
                    assertTrue(attachment.getSize() > 0);
                    assertFalse(attachment.getPathId().isEmpty());

                    UserAttachmentMessage message = optional.get();
                    assertEquals(messageId, message.getId());
                    assertTrue(message.getDateSent().toEpochMilli() > 0);
                }
            }
        }

        assertTrue(matched);
    }

    @Test
    public void setTyping() throws ZulipClientException {
        zulip.users().setTyping(TypingOperation.START, ownUser.getUserId()).execute();
        zulip.users().setTyping(TypingOperation.STOP, ownUser.getUserId()).execute();
    }

    @Test
    public void userPresence() throws ZulipClientException {
        Map<String, UserPresenceDetail> userPresence = zulip.users().getUserPresence("test@test.com").execute();
        assertFalse(userPresence.isEmpty());

        UserPresenceDetail aggregated = userPresence.get("aggregated");
        assertNotNull(aggregated);
        assertNotNull(aggregated.getStatus());
        assertTrue(aggregated.getTimestamp().toEpochMilli() > 0);

        UserPresenceDetail website = userPresence.get("website");
        assertNotNull(website);
        assertNotNull(website.getStatus());
        assertTrue(website.getTimestamp().toEpochMilli() > 0);
    }

    @Test
    public void updateNotificationSettings() throws ZulipClientException {
        try {
            Map<String, Object> settings = zulip.users().updateNotificationSettings()
                    .withDesktopIconCountDisplay(DesktopIconCountDisplay.NONE)
                    .withEnableDesktopNotifications(false)
                    .withEnableStreamAudibleNotifications(true)
                    .execute();

            assertEquals(3, settings.size());
            assertEquals(settings.get(UpdateNotificationSettingsApiRequest.DESKTOP_ICON_COUNT_DISPLAY),
                    DesktopIconCountDisplay.NONE.getSetting());
            assertEquals(settings.get(UpdateNotificationSettingsApiRequest.ENABLE_DESKTOP_NOTIFICATIONS), false);
            assertEquals(settings.get(UpdateNotificationSettingsApiRequest.ENABLE_STREAM_AUDIBLE_NOTIFICATIONS), true);

            // Reset settings
            zulip.users().updateNotificationSettings()
                    .withDesktopIconCountDisplay(DesktopIconCountDisplay.ALL_UNREADS)
                    .withEnableDesktopNotifications(true)
                    .withEnableStreamAudibleNotifications(false)
                    .execute();
        } catch (Throwable t) {
            zulip.users().updateNotificationSettings()
                    .withDesktopIconCountDisplay(DesktopIconCountDisplay.ALL_UNREADS)
                    .withEnableDesktopNotifications(true)
                    .withEnableStreamAudibleNotifications(false)
                    .execute();
        }
    }

    @Test
    public void userGroupCrud() throws ZulipClientException {
        // Create group
        zulip.users().createUserGroup("Test Group Name", "Test Group Description", ownUser.getUserId()).execute();

        // Get group
        List<UserGroup> groups = zulip.users().getUserGroups().execute();
        assertEquals(1, groups.size());

        UserGroup group = groups.get(0);
        assertEquals("Test Group Name", group.getName());
        assertEquals("Test Group Description", group.getDescription());
        assertTrue(group.getId() > 0);

        List<Long> members = group.getMembers();
        assertEquals(1, members.size());
        assertTrue(members.contains(ownUser.getUserId()));

        // Update group
        zulip.users().updateUserGroup("Updated Group Name", "Updated Group Description", group.getId()).execute();

        groups = zulip.users().getUserGroups().execute();
        assertEquals(1, groups.size());

        group = groups.get(0);
        assertEquals("Updated Group Name", group.getName());
        assertEquals("Updated Group Description", group.getDescription());

        // Add new user to group
        String id = UUID.randomUUID().toString().split("-")[0];

        zulip.users().createUser(id + "@test.com", id, "T00s3cr3t").execute();

        List<User> users = zulip.users().getAllUsers().execute();
        User createdUser = users.stream()
                .filter(User::isActive)
                .filter(u -> u.getEmail().equals(id + "@test.com"))
                .findFirst()
                .get();
        assertNotNull(createdUser);

        zulip.users().addUsersToGroup(group.getId(), createdUser.getUserId()).execute();

        groups = zulip.users().getUserGroups().execute();
        group = groups.get(0);
        members = group.getMembers();
        assertEquals(2, members.size());
        assertTrue(members.contains(ownUser.getUserId()));
        assertTrue(members.contains(createdUser.getUserId()));

        // Remove user from group
        zulip.users().removeUsersFromGroup(group.getId(), createdUser.getUserId()).execute();

        groups = zulip.users().getUserGroups().execute();
        group = groups.get(0);
        members = group.getMembers();
        assertEquals(1, members.size());
        assertTrue(members.contains(ownUser.getUserId()));

        // Delete group
        zulip.users().deleteUserGroup(group.getId()).execute();
        groups = zulip.users().getUserGroups().execute();
        assertTrue(groups.isEmpty());
    }
}

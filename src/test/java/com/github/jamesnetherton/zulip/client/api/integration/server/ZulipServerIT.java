package com.github.jamesnetherton.zulip.client.api.integration.server;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.fail;

import com.github.jamesnetherton.zulip.client.api.integration.ZulipIntegrationTestBase;
import com.github.jamesnetherton.zulip.client.api.server.AuthenticationSettings;
import com.github.jamesnetherton.zulip.client.api.server.CustomEmoji;
import com.github.jamesnetherton.zulip.client.api.server.EmailAddressVisibilityPolicy;
import com.github.jamesnetherton.zulip.client.api.server.Linkifier;
import com.github.jamesnetherton.zulip.client.api.server.MarkReadOnScrollPolicy;
import com.github.jamesnetherton.zulip.client.api.server.ProfileField;
import com.github.jamesnetherton.zulip.client.api.server.ProfileFieldType;
import com.github.jamesnetherton.zulip.client.api.server.RealmNameInNotificationsPolicy;
import com.github.jamesnetherton.zulip.client.api.server.ServerSettings;
import com.github.jamesnetherton.zulip.client.api.server.TopicFollowPolicy;
import com.github.jamesnetherton.zulip.client.api.server.UnmuteTopicInMutedStreamsPolicy;
import com.github.jamesnetherton.zulip.client.api.server.WebStreamUnreadsCountDisplayPolicy;
import com.github.jamesnetherton.zulip.client.api.user.ColorScheme;
import com.github.jamesnetherton.zulip.client.api.user.DemoteInactiveStreamOption;
import com.github.jamesnetherton.zulip.client.api.user.DesktopIconCountDisplay;
import com.github.jamesnetherton.zulip.client.api.user.EmojiSet;
import com.github.jamesnetherton.zulip.client.api.user.UserListStyle;
import com.github.jamesnetherton.zulip.client.api.user.WebHomeView;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import org.junit.jupiter.api.Test;

public class ZulipServerIT extends ZulipIntegrationTestBase {

    @Test
    public void linkifierCrud() throws ZulipClientException {
        // Create linikifier
        Long id = zulip.server().addLinkifier("#(?P<id>[0-9]+)", "https://github.com/zulip/zulip/issues/{id}s").execute();
        assertTrue(id > 0);

        try {
            // Get linkifiers
            List<Linkifier> linkifiers = zulip.server().getLinkifiers().execute();
            assertEquals(1, linkifiers.size());

            Linkifier linkifier = linkifiers.get(0);
            assertEquals(id, linkifier.getId());
            assertEquals("#(?P<id>[0-9]+)", linkifier.getPattern());
            assertEquals("https://github.com/zulip/zulip/issues/{id}s", linkifier.getUrlTemplate());

            // Update linkifier
            zulip.server().updateLinkifier(linkifier.getId(), "#(?P<id>[0-5]+)", "https://github.com/zulip/zulip/pulls/{id}s")
                    .execute();

            linkifiers = zulip.server().getLinkifiers().execute();
            assertEquals(1, linkifiers.size());

            linkifier = linkifiers.get(0);
            assertEquals(id, linkifier.getId());
            assertEquals("#(?P<id>[0-5]+)", linkifier.getPattern());
            assertEquals("https://github.com/zulip/zulip/pulls/{id}s", linkifier.getUrlTemplate());

            // Reorder linkifiers
            Collections.reverse(linkifiers);
            long[] newOrder = linkifiers.stream().mapToLong(Linkifier::getId).toArray();
            zulip.server().reorderLinkifiers(newOrder).execute();

            // Delete linkifiers
            zulip.server().deleteLinkifier(id).execute();
        } catch (Throwable t) {
            try {
                zulip.server().deleteLinkifier(id).execute();
            } catch (Throwable t2) {
                // Ignore
            }
            throw t;
        }

        List<Linkifier> linkifiers = zulip.server().getLinkifiers().execute();
        assertTrue(linkifiers.isEmpty());
    }

    @Test
    public void emoji() throws ZulipClientException {
        File file = new File("./src/test/resources/com/github/jamesnetherton/zulip/client/api/server/emoji/smile.png");

        String emojiName = UUID.randomUUID().toString().split("-")[0];
        zulip.server().uploadEmoji(emojiName, file).execute();

        List<CustomEmoji> emojis = zulip.server().getEmoji().execute();
        Optional<CustomEmoji> optional = emojis.stream()
                .filter(e -> e.getName().equals(emojiName))
                .findFirst();

        assertTrue(optional.isPresent());

        CustomEmoji emoji = optional.get();
        assertEquals(emojiName, emoji.getName());
        assertTrue(emoji.getSourceUrl().endsWith(".png"));
        assertNull(emoji.getStillUrl());
        assertTrue(emoji.getAuthorId() > 0);
        assertTrue(emoji.getId() > 0);
        assertFalse(emoji.isDeactivated());
    }

    @Test
    public void serverSettings() throws ZulipClientException {
        ServerSettings settings = zulip.server().getServerSettings().execute();

        assertTrue(settings.isEmailAuthEnabled());
        assertFalse(settings.isRealmWebPublicAccessEnabled());
        assertTrue(settings.isRequireEmailFormatUsernames());
        assertFalse(settings.isIncompatible());
        assertFalse(settings.isPushNotificationsEnabled());
        assertEquals("testing", settings.getRealmName());
        assertEquals("<p>The coolest place in the universe.</p>", settings.getRealmDescription());
        assertTrue(settings.getRealmIcon().startsWith("https://secure.gravatar.com"));

        AuthenticationSettings authenticationMethods = settings.getAuthenticationMethods();
        assertFalse(authenticationMethods.isAzuread());
        assertFalse(authenticationMethods.isDev());
        assertTrue(authenticationMethods.isEmail());
        assertFalse(authenticationMethods.isGithub());
        assertFalse(authenticationMethods.isGoogle());
        assertFalse(authenticationMethods.isLdap());
        assertTrue(authenticationMethods.isPassword());
        assertFalse(authenticationMethods.isRemoteuser());
        assertFalse(authenticationMethods.isSaml());

        assertTrue(settings.getExternalAuthenticationMethods().isEmpty());
    }

    @SuppressWarnings("unchecked")
    @Test
    public void customProfileFieldsCrud() throws ZulipClientException {
        long simpleId = zulip.server().createCustomProfileField()
                .withSimpleFieldType(ProfileFieldType.LONG_TEXT, "Test Long Name", "Test Long Hint")
                .execute();
        assertTrue(simpleId > 0);

        Map<String, Map<String, String>> listData = new LinkedHashMap<>();
        Map<String, String> child = new LinkedHashMap<>();
        child.put("text", "Vim");
        child.put("order", "1");
        listData.put("vim", child);

        long listId = zulip.server().createCustomProfileField()
                .withListOfOptionsFieldType("Test List Name", "Test List Hint", listData)
                .execute();
        assertTrue(listId > 0);

        Map<String, String> externalData = new LinkedHashMap<>();
        externalData.put("subtype", "github");

        long externalId = zulip.server().createCustomProfileField()
                .withExternalAccountFieldType(externalData)
                .withDisplayInProfileSummary(true)
                .execute();
        assertTrue(externalId > 0);

        List<ProfileField> profileFields = zulip.server().getCustomProfileFields().execute();
        assertEquals(3, profileFields.size());

        List<Integer> order = new ArrayList<>();

        for (ProfileField field : profileFields) {
            if (field.getId() == simpleId) {
                assertEquals("Test Long Hint", field.getHint());
                assertEquals("Test Long Name", field.getName());
                assertTrue(field.getOrder() > 0);
                assertEquals(ProfileFieldType.LONG_TEXT, field.getType());
                assertEquals("", field.getFieldData());
                order.add(field.getOrder());
            } else if (field.getId() == listId) {
                assertEquals("Test List Hint", field.getHint());
                assertEquals("Test List Name", field.getName());
                assertTrue(field.getOrder() > 0);
                assertEquals(ProfileFieldType.LIST_OF_OPTIONS, field.getType());

                Map<String, Map<String, String>> data = (Map<String, Map<String, String>>) field.getFieldData();
                assertEquals(1, data.size());

                Map<String, String> vim = data.get("vim");
                assertNotNull(vim);
                assertEquals(2, vim.size());
                assertEquals("Vim", vim.get("text"));
                assertEquals("1", vim.get("order"));
                order.add(field.getOrder());
            } else if (field.getId() == externalId) {
                assertEquals("", field.getHint());
                assertEquals("GitHub username", field.getName());
                assertTrue(field.getOrder() > 0);
                assertEquals(ProfileFieldType.EXTERNAL_ACCOUNT, field.getType());
                assertTrue(field.isDisplayInProfileSummary());

                Map<String, String> data = (Map<String, String>) field.getFieldData();
                assertEquals(1, data.size());
                assertEquals("github", data.get("subtype"));
                order.add(field.getOrder());
            } else {
                fail("Unexpected profile entry found");
            }
        }

        Collections.reverse(order);
        zulip.server().reorderCustomProfileFields(order.get(0), order.get(1), order.get(2)).execute();

        zulip.server().deleteCustomProfileField(simpleId).execute();
        zulip.server().deleteCustomProfileField(listId).execute();
        zulip.server().deleteCustomProfileField(externalId).execute();
    }

    @Test
    public void getApiKey() throws ZulipClientException {
        try {
            String key = zulip.server().getApiKey("test@test.com", "testing123").execute();
            assertFalse(key.isEmpty());
        } catch (ZulipClientException e) {
            // Ignore if dev not enabled
            if (!e.getMessage().equals("Dev environment not enabled.")) {
                throw e;
            }
        }
    }

    @Test
    public void codePlayground() throws ZulipClientException {
        long id = zulip.server().addCodePlayground("test", "java", "http://localhost/java/playground?code={code}").execute();
        zulip.server().removeCodePlayground(id).execute();
    }

    @Test
    public void updateRealmNewUserDefaultSettings() throws ZulipClientException {
        List<String> result = zulip.server().updateRealmNewUserDefaultSettings()
                .withAutomaticallyFollowTopicsPolicy(TopicFollowPolicy.PARTICIPATING)
                .withAutomaticallyUnmuteTopicsInMutedStreamsPolicy(UnmuteTopicInMutedStreamsPolicy.PARTICIPATING)
                .withAutomaticallyFollowTopicsWhereMentioned(true)
                .withColorScheme(ColorScheme.DARK)
                .withWebHomeView(WebHomeView.RECENT_TOPICS)
                .withDemoteInactiveStreams(DemoteInactiveStreamOption.ALWAYS)
                .withDesktopIconCountDisplay(DesktopIconCountDisplay.ALL_UNREADS)
                .withDisplayEmojiReactionUsers(true)
                .withEmailNotificationsBatchingPeriodSeconds(60)
                .withEmailAddressVisibility(EmailAddressVisibilityPolicy.EVERYONE)
                .withEmojiSet(EmojiSet.TWITTER)
                .withEnableDesktopNotifications(true)
                .withEnableDigestEmails(true)
                .withEnableDraftsSynchronization(true)
                .withEnableFollowedTopicAudibleNotifications(true)
                .withEnableFollowedTopicDesktopNotifications(true)
                .withEnableFollowedTopicEmailNotifications(true)
                .withEnableFollowedTopicPushNotifications(true)
                .withEnableFollowedTopicWildcardMentionsNotify(true)
                .withEnableOfflineEmailNotifications(true)
                .withEnableOfflinePushNotifications(true)
                .withEnableOnlinePushNotifications(true)
                .withEnableSounds(true)
                .withEnableStreamAudibleNotifications(true)
                .withEnableStreamDesktopNotifications(true)
                .withEnableStreamEmailNotifications(true)
                .withEnableStreamPushNotifications(true)
                .withEnterSends(true)
                .withWebEscapeNavigatesToHomeView(true)
                .withFluidLayoutWidth(true)
                .withHighContrastMode(true)
                .withLeftSideUserList(true)
                .withMessageContentInEmailNotifications(true)
                .withNotificationSound("ding")
                .withPmContentInDesktopNotifications(true)
                .withPresenceEnabled(true)
                .withRealmNameInNotifications(true)
                .withRealmNameInEmailNotifications(RealmNameInNotificationsPolicy.ALWAYS)
                .withSendPrivateTypingNotifications(true)
                .withSendReadReceipts(true)
                .withSendStreamTypingNotifications(true)
                .withStarredMessageCounts(true)
                .withTranslateEmoticons(true)
                .withTwentyFourHourTime(true)
                .withUserListStyle(UserListStyle.WITH_STATUS)
                .withWebMarkReadOnScrollPolicy(MarkReadOnScrollPolicy.CONSERVATION_VIEWS)
                .withWebStreamUnreadsCountDisplayPolicy(WebStreamUnreadsCountDisplayPolicy.ALL_STREAMS)
                .withWildcardMentionsNotify(true)
                .execute();

        assertNotNull(result);
    }
}

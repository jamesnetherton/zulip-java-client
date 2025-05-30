package com.github.jamesnetherton.zulip.client.api.server;

import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.DELETE;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.GET;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.PATCH;
import static com.github.jamesnetherton.zulip.client.ZulipApiTestBase.HttpMethod.POST;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.github.jamesnetherton.zulip.client.ZulipApiTestBase;
import com.github.jamesnetherton.zulip.client.api.server.request.AddApnsDeviceTokenApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.AddCodePlaygroundApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.AddFcmRegistrationTokenApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.AddLinkifierApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.CreateBigBlueButtonVideoCallApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.CreateDataExportApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.CreateProfileFieldApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.GetApiKeyApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.RemoveApnsDeviceTokenApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.RemoveFcmRegistrationTokenApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.ReorderLinkifiersApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.ReorderProfileFieldsApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.request.SendMobilePushTestNotification;
import com.github.jamesnetherton.zulip.client.api.server.request.UpdateRealmNewUserDefaultSettingsApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.ColorScheme;
import com.github.jamesnetherton.zulip.client.api.user.DemoteInactiveStreamOption;
import com.github.jamesnetherton.zulip.client.api.user.DesktopIconCountDisplay;
import com.github.jamesnetherton.zulip.client.api.user.EmojiSet;
import com.github.jamesnetherton.zulip.client.api.user.UserListStyle;
import com.github.jamesnetherton.zulip.client.api.user.WebAnimateImageOption;
import com.github.jamesnetherton.zulip.client.api.user.WebChannelView;
import com.github.jamesnetherton.zulip.client.api.user.WebHomeView;
import com.github.tomakehurst.wiremock.matching.StringValuePattern;
import java.io.File;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.Test;

public class ZulipServerApiTest extends ZulipApiTestBase {

    @Test
    public void addLinkfier() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddLinkifierApiRequest.PATTERN, "some regex")
                .add(AddLinkifierApiRequest.URL_TEMPLATE, "https://github.com/zulip/zulip/issues/%s")
                .get();

        stubZulipResponse(POST, "/realm/filters", params, "addLinkifier.json");

        Long id = zulip.server().addLinkifier("some regex", "https://github.com/zulip/zulip/issues/%s").execute();
        assertEquals(42, id);
    }

    @Test
    public void updateLinkifier() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddLinkifierApiRequest.PATTERN, "updated regex")
                .add(AddLinkifierApiRequest.URL_TEMPLATE, "https://github.com/zulip/zulip-updated/issues/%s")
                .get();

        stubZulipResponse(PATCH, "/realm/filters/1", params);

        zulip.server().updateLinkifier(1, "updated regex", "https://github.com/zulip/zulip-updated/issues/%s").execute();
    }

    @Test
    public void deleteLinkifier() throws Exception {
        stubZulipResponse(DELETE, "/realm/filters/1", Collections.emptyMap());

        zulip.server().deleteLinkifier(1).execute();
    }

    @Test
    public void getLinkifiers() throws Exception {
        stubZulipResponse(GET, "/realm/linkifiers", Collections.emptyMap(), "getLinkifiers.json");

        List<Linkifier> linkifiers = zulip.server().getLinkifiers().execute();
        assertEquals(2, linkifiers.size());

        Linkifier linkifierA = linkifiers.get(0);
        assertEquals("#(?P<id>[0-9]+)", linkifierA.getPattern());
        assertEquals("https://github.com/zulip/zulip/issues/{id}s", linkifierA.getUrlTemplate());
        assertEquals(1, linkifierA.getId());

        Linkifier linkifierB = linkifiers.get(1);
        assertEquals("(?P<id>[0-9a-f]{40})", linkifierB.getPattern());
        assertEquals("https://github.com/zulip/zulip/commit/{id}s", linkifierB.getUrlTemplate());
        assertEquals(2, linkifierB.getId());
    }

    @Test
    public void getEmptyLinkifiers() throws Exception {
        stubZulipResponse(GET, "/realm/linkifiers", Collections.emptyMap(), "getLinkifiersEmpty.json");

        List<Linkifier> linkifiers = zulip.server().getLinkifiers().execute();
        assertTrue(linkifiers.isEmpty());
    }

    @Test
    public void reorderLinkifiers() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(ReorderLinkifiersApiRequest.ORDERED_LINKIFIER_IDS, "[5,4,3,2,1]")
                .get();

        stubZulipResponse(PATCH, "/realm/linkifiers", params);

        zulip.server().reorderLinkifiers(5, 4, 3, 2, 1).execute();
    }

    @Test
    public void uploadEmoji() throws Exception {
        stubZulipResponse(POST, "/realm/emoji/test", Collections.emptyMap());

        File file = new File("./src/test/resources/com/github/jamesnetherton/zulip/client/api/server/emoji/smile.png");

        zulip.server().uploadEmoji("test", file).execute();
    }

    @Test
    public void getEmoji() throws Exception {
        stubZulipResponse(GET, "/realm/emoji", Collections.emptyMap(), "getEmoji.json");

        List<CustomEmoji> emojis = zulip.server().getEmoji().execute();
        for (int i = 1; i <= emojis.size(); i++) {
            CustomEmoji emoji = emojis.get(i - 1);
            assertEquals("emoji" + i, emoji.getName());
            assertEquals("/user_avatars/" + i + "/emoji/images/" + i + ".png", emoji.getSourceUrl());
            assertEquals("/user_avatars/" + i + "/emoji/images/still_" + i + ".png", emoji.getStillUrl());
            assertEquals(i, emoji.getAuthorId());
            assertEquals(i, emoji.getId());
            assertEquals(i != 1, emoji.isDeactivated());
        }
    }

    @Test
    public void getServerSettings() throws Exception {
        stubZulipResponse(GET, "/server_settings", Collections.emptyMap(), "getServerSettings.json");

        ServerSettings settings = zulip.server().getServerSettings().execute();
        assertFalse(settings.isIncompatible());
        assertFalse(settings.isPushNotificationsEnabled());
        assertTrue(settings.isRealmWebPublicAccessEnabled());
        assertTrue(settings.isRequireEmailFormatUsernames());
        assertEquals("<p>Test Realm Description</p>", settings.getRealmDescription());
        assertEquals("https://foo/bar/icon.png", settings.getRealmIcon());
        assertEquals("Test Realm Name", settings.getRealmName());
        assertEquals("http://localhost:8080", settings.getRealmUri());
        assertEquals("http://localhost:8080", settings.getRealmUrl());
        assertEquals("5.6.7", settings.getZulipMergeBase());
        assertEquals("1.2.3", settings.getZulipVersion());
        assertTrue(settings.isEmailAuthEnabled());

        AuthenticationSettings authenticationMethods = settings.getAuthenticationMethods();
        assertFalse(authenticationMethods.isAzuread());
        assertTrue(authenticationMethods.isDev());
        assertTrue(authenticationMethods.isEmail());
        assertTrue(authenticationMethods.isGithub());
        assertTrue(authenticationMethods.isGoogle());
        assertFalse(authenticationMethods.isLdap());
        assertTrue(authenticationMethods.isPassword());
        assertFalse(authenticationMethods.isRemoteuser());
        assertTrue(authenticationMethods.isSaml());

        List<ExternalAuthenticationSettings> externalAuthenticationMethods = settings.getExternalAuthenticationMethods();
        assertEquals(3, externalAuthenticationMethods.size());

        ExternalAuthenticationSettings externalA = externalAuthenticationMethods.get(0);
        assertNull(externalA.getDisplayIcon());
        assertEquals("SAML", externalA.getDisplayName());
        assertEquals("/accounts/login/social/saml/idp_name", externalA.getLoginUrl());
        assertEquals("saml:idp_name", externalA.getName());
        assertEquals("/accounts/register/social/saml/idp_name", externalA.getSignupUrl());

        ExternalAuthenticationSettings externalB = externalAuthenticationMethods.get(1);
        assertEquals("/static/images/landing-page/logos/googl_e-icon.png", externalB.getDisplayIcon());
        assertEquals("Google", externalB.getDisplayName());
        assertEquals("/accounts/login/social/google", externalB.getLoginUrl());
        assertEquals("google", externalB.getName());
        assertEquals("/accounts/register/social/google", externalB.getSignupUrl());

        ExternalAuthenticationSettings externalC = externalAuthenticationMethods.get(2);
        assertEquals("/static/images/landing-page/logos/github-icon.png", externalC.getDisplayIcon());
        assertEquals("GitHub", externalC.getDisplayName());
        assertEquals("/accounts/login/social/github", externalC.getLoginUrl());
        assertEquals("github", externalC.getName());
        assertEquals("/accounts/register/social/github", externalC.getSignupUrl());
    }

    @SuppressWarnings("unchecked")
    @Test
    public void customProfileFields() throws Exception {
        stubZulipResponse(GET, "/realm/profile_fields", Collections.emptyMap(), "getCustomProfileFields.json");

        List<ProfileField> profileFields = zulip.server().getCustomProfileFields().execute();
        for (int i = 1; i <= profileFields.size(); i++) {
            ProfileField field = profileFields.get(i - 1);
            assertEquals("Hint " + i, field.getHint());
            assertEquals("Field " + i, field.getName());
            assertEquals(i, field.getId());
            assertEquals(i, field.getOrder());
            assertEquals(ProfileFieldType.fromInt(field.getType().getId()), field.getType());
            assertEquals(i == 1, field.isDisplayInProfileSummary());
            if (i == 1) {
                assertTrue(field.isRequired());
                assertTrue(field.isEditableByUser());
            } else {
                assertFalse(field.isRequired());
                assertFalse(field.isEditableByUser());
            }

            if (field.getType().equals(ProfileFieldType.LIST_OF_OPTIONS)) {
                Map<String, Map<String, String>> data = (Map<String, Map<String, String>>) field.getFieldData();
                assertEquals(2, data.size());

                Map<String, String> vim = data.get("vim");
                assertNotNull(vim);
                assertEquals(2, vim.size());
                assertEquals("Vim", vim.get("text"));
                assertEquals("1", vim.get("order"));

                Map<String, String> emacs = data.get("emacs");
                assertNotNull(emacs);
                assertEquals(2, emacs.size());
                assertEquals("Emacs", emacs.get("text"));
                assertEquals("2", emacs.get("order"));
            } else if (field.getType().equals(ProfileFieldType.EXTERNAL_ACCOUNT)) {
                Map<String, String> data = (Map<String, String>) field.getFieldData();
                assertEquals(1, data.size());
                assertEquals("foo", data.get("subtype"));
            } else if (field.getType().equals(ProfileFieldType.UNKNOWN)) {
                assertEquals(6, field.getId());
            } else {
                assertEquals("Data " + i, field.getFieldData());
            }
        }
    }

    @Test
    public void reorderProfileFields() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(ReorderProfileFieldsApiRequest.ORDER, "[5,4,3,2,1]")
                .get();

        stubZulipResponse(PATCH, "/realm/profile_fields", params);

        zulip.server().reorderCustomProfileFields(5, 4, 3, 2, 1).execute();
    }

    @Test
    public void deleteProfileField() throws Exception {
        stubZulipResponse(DELETE, "/realm/profile_fields/1", Collections.emptyMap());

        zulip.server().deleteCustomProfileField(1).execute();
    }

    @Test
    public void createSimpleCustomProfileField() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateProfileFieldApiRequest.NAME, "Test Name")
                .add(CreateProfileFieldApiRequest.HINT, "Test Hint")
                .add(CreateProfileFieldApiRequest.FIELD_TYPE, "2")
                .add(CreateProfileFieldApiRequest.DISPLAY_IN_PROFILE_SUMMARY, "true")
                .add(CreateProfileFieldApiRequest.REQUIRED, "true")
                .add(CreateProfileFieldApiRequest.EDITABLE_BY_USER, "true")
                .get();

        stubZulipResponse(POST, "/realm/profile_fields", params, "createProfileField.json");

        long id = zulip.server().createCustomProfileField()
                .withEditableByUser(true)
                .withSimpleFieldType(ProfileFieldType.LONG_TEXT, "Test Name", "Test Hint")
                .withDisplayInProfileSummary(true)
                .withRequired(true)
                .execute();

        assertEquals(9, id);
    }

    @Test
    public void createListCustomProfileField() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateProfileFieldApiRequest.NAME, "Test Name")
                .add(CreateProfileFieldApiRequest.HINT, "Test Hint")
                .add(CreateProfileFieldApiRequest.FIELD_TYPE, "3")
                .add(CreateProfileFieldApiRequest.FIELD_DATA, "{\"test\":{\"foo\":\"bar\"}}")
                .get();

        stubZulipResponse(POST, "/realm/profile_fields", params, "createProfileField.json");

        Map<String, Map<String, String>> data = new LinkedHashMap<>();
        Map<String, String> child = new LinkedHashMap<>();
        child.put("foo", "bar");
        data.put("test", child);

        long id = zulip.server().createCustomProfileField()
                .withListOfOptionsFieldType("Test Name", "Test Hint", data)
                .execute();

        assertEquals(9, id);
    }

    @Test
    public void createExternalCustomProfileField() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateProfileFieldApiRequest.FIELD_TYPE, "7")
                .add(CreateProfileFieldApiRequest.FIELD_DATA, "{\"foo\":\"bar\"}")
                .get();

        stubZulipResponse(POST, "/realm/profile_fields", params, "createProfileField.json");

        Map<String, String> data = new LinkedHashMap<>();
        data.put("foo", "bar");

        long id = zulip.server().createCustomProfileField()
                .withExternalAccountFieldType(data)
                .execute();

        assertEquals(9, id);
    }

    @Test
    public void getDevelopmentApiKey() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetApiKeyApiRequest.USERNAME, "test@test.com")
                .get();

        stubZulipResponse(POST, "/dev_fetch_api_key", params, "getApiKey.json");

        String key = zulip.server().getDevelopmentApiKey("test@test.com").execute();

        assertEquals("abc123zxy", key);
    }

    @Test
    public void getProductionApiKey() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(GetApiKeyApiRequest.USERNAME, "test@test.com")
                .add(GetApiKeyApiRequest.PASSWORD, "test")
                .get();

        stubZulipResponse(POST, "/fetch_api_key", params, "getApiKey.json");

        String key = zulip.server().getApiKey("test@test.com", "test").execute();

        assertEquals("abc123zxy", key);
    }

    @Test
    public void addCodePlayground() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddCodePlaygroundApiRequest.NAME, "Test Playground")
                .add(AddCodePlaygroundApiRequest.PYGMENTS_LANGUAGE, "java")
                .add(AddCodePlaygroundApiRequest.URL_TEMPLATE, "https://localhost/prefix")
                .get();

        stubZulipResponse(POST, "/realm/playgrounds", params, "addCodePlayground.json");

        long id = zulip.server().addCodePlayground("Test Playground", "java", "https://localhost/prefix").execute();
        assertEquals(1, id);
    }

    @Test
    public void removeCodePlayground() throws Exception {
        stubZulipResponse(DELETE, "/realm/playgrounds/1", Collections.emptyMap());

        zulip.server().removeCodePlayground(1).execute();
    }

    @Test
    public void updateRealmNewUserDefaultSettings() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.AUTOMATICALLY_FOLLOW_TOPICS_POLICY, "1")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.AUTOMATICALLY_UNMUTE_TOPICS_IN_MUTED_STREAMS_POLICY, "1")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.AUTOMATICALLY_FOLLOW_TOPICS_WHERE_MENTIONED, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.COLOR_SCHEME, String.valueOf(ColorScheme.DARK.getId()))
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_HOME_VIEW, WebHomeView.RECENT_TOPICS.toString())
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.DEMOTE_INACTIVE_STREAMS,
                        String.valueOf(DemoteInactiveStreamOption.ALWAYS.getId()))
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.DESKTOP_ICON_COUNT_DISPLAY,
                        String.valueOf(DesktopIconCountDisplay.ALL_UNREADS.getSetting()))
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.DISPLAY_EMOJI_REACTION_USERS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.EMAIL_ADDRESS_VISIBILITY, "1")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.EMAIL_NOTIFICATIONS_BATCHING_PERIOD_SECONDS, "60")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.EMOJISET, EmojiSet.TWITTER.toString())
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_DIGEST_EMAILS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_DRAFTS_SYNCHRONIZATION, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_FOLLOWED_TOPIC_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_FOLLOWED_TOPIC_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_FOLLOWED_TOPIC_PUSH_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_FOLLOWED_TOPIC_AUDIBLE_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_FOLLOWED_TOPIC_WILDCARD_MENTIONS_NOTIFY, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_OFFLINE_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_OFFLINE_PUSH_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_ONLINE_PUSH_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_SOUNDS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_STREAM_AUDIBLE_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_STREAM_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_STREAM_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENABLE_STREAM_PUSH_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.ENTER_SENDS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_ESCAPE_NAVIGATES_TO_HOME_VIEW, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.FLUID_LAYOUT_WIDTH, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.HIGH_CONTRAST_MODE, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.LEFT_SIDE_USERLIST, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.MESSAGE_CONTENT_IN_EMAIL_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.NOTIFICATION_SOUND, "ding")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.PM_CONTENT_IN_DESKTOP_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.PRESENCE_ENABLED, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.REALM_NAME_IN_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.REALM_NAME_IN_EMAIL_NOTIFICATIONS_POLICY, "2")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.RECEIVES_TYPING_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.SEND_READ_RECEIPTS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.SEND_PRIVATE_TYPING_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.SEND_STREAM_TYPING_NOTIFICATIONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.STARRED_MESSAGE_COUNTS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.TRANSLATE_EMOTICONS, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.TWENTY_FOUR_HOUR_TIME, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.USER_LIST_STYLE, "2")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_ANIMATE_IMAGE_PREVIEWS, "on_hover")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_CHANNEL_DEFAULT_VIEW, "2")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_FONT_SIZE_PX, "11")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_LINE_HEIGHT_PERCENT, "120")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_MARK_READ_ON_SCROLL_POLICY, "2")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_STREAM_UNREADS_COUNT_DISPLAY_POLICY, "2")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_NAVIGATE_TO_SENT_MESSAGE, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WEB_SUGGEST_UPDATE_TIMEZONE, "true")
                .add(UpdateRealmNewUserDefaultSettingsApiRequest.WILDCARD_MENTIONS_NOTIFY, "true")
                .get();

        stubZulipResponse(PATCH, "/realm/user_settings_defaults", params, "updateRealmNewUserDefaultSettings.json");

        List<String> result = zulip.server().updateRealmNewUserDefaultSettings()
                .withAutomaticallyFollowTopicsPolicy(TopicFollowPolicy.PARTICIPATING)
                .withAutomaticallyUnmuteTopicsInMutedStreamsPolicy(UnmuteTopicInMutedStreamsPolicy.PARTICIPATING)
                .withAutomaticallyFollowTopicsWhereMentioned(true)
                .withColorScheme(ColorScheme.DARK)
                .withWebHomeView(WebHomeView.RECENT_TOPICS)
                .withDemoteInactiveStreams(DemoteInactiveStreamOption.ALWAYS)
                .withDesktopIconCountDisplay(DesktopIconCountDisplay.ALL_UNREADS)
                .withDisplayEmojiReactionUsers(true)
                .withEmailAddressVisibility(EmailAddressVisibilityPolicy.EVERYONE)
                .withEmailNotificationsBatchingPeriodSeconds(60)
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
                .withReceivesTypingNotifications(true)
                .withSendPrivateTypingNotifications(true)
                .withSendReadReceipts(true)
                .withSendStreamTypingNotifications(true)
                .withStarredMessageCounts(true)
                .withTranslateEmoticons(true)
                .withTwentyFourHourTime(true)
                .withUserListStyle(UserListStyle.WITH_STATUS)
                .withWebAnimateImagePreviews(WebAnimateImageOption.ON_HOVER)
                .withWebChannelDefaultView(WebChannelView.CHANNEL_FEED)
                .withWebFontPx(11)
                .withWebLineHeightPercent(120)
                .withWebMarkReadOnScrollPolicy(MarkReadOnScrollPolicy.CONSERVATION_VIEWS)
                .withWebStreamUnreadsCountDisplayPolicy(WebStreamUnreadsCountDisplayPolicy.UNMUTED_STREAMS_TOPICS)
                .withWebNavigateToSentMessage(true)
                .withWebSuggestUpdateTimezone(true)
                .withWildcardMentionsNotify(true)
                .execute();

        assertNotNull(result);
        assertEquals(2, result.size());
        assertEquals("desktop_notifications", result.get(0));
        assertEquals("demote_streams", result.get(1));
    }

    @Test
    public void sendMobilePushTestNotification() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(SendMobilePushTestNotification.TOKEN, "abc123")
                .get();

        stubZulipResponse(POST, "/mobile_push/test_notification", params, SUCCESS_JSON);

        zulip.server().sendMobilePushTestNotification()
                .withToken("abc123")
                .execute();
    }

    @Test
    public void addApnsDeviceToken() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddApnsDeviceTokenApiRequest.TOKEN, "abc123")
                .add(AddApnsDeviceTokenApiRequest.APP_ID, "456def")
                .get();

        stubZulipResponse(POST, "/users/me/apns_device_token", params, SUCCESS_JSON);

        zulip.server().addApnsDeviceToken("abc123", "456def").execute();
    }

    @Test
    public void removeApnsDeviceToken() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(RemoveApnsDeviceTokenApiRequest.TOKEN, "abc123")
                .get();

        stubZulipResponse(DELETE, "/users/me/apns_device_token", params, SUCCESS_JSON);

        zulip.server().removeApnsDeviceToken("abc123").execute();
    }

    @Test
    public void addFcmRegistrationToken() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(AddFcmRegistrationTokenApiRequest.TOKEN, "abc123")
                .get();

        stubZulipResponse(POST, "/users/me/android_gcm_reg_id", params, SUCCESS_JSON);

        zulip.server().addFcmRegistrationToken("abc123").execute();
    }

    @Test
    public void removeFcmRegistrationToken() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(RemoveFcmRegistrationTokenApiRequest.TOKEN, "abc123")
                .get();

        stubZulipResponse(DELETE, "/users/me/android_gcm_reg_id", params, SUCCESS_JSON);

        zulip.server().removeFcmRegistrationToken("abc123").execute();
    }

    @Test
    public void createBigBlueButtonMeeting() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateBigBlueButtonVideoCallApiRequest.MEETING_NAME, "Test Meeting")
                .get();

        stubZulipResponse(GET, "/calls/bigbluebutton/create", params, "createBigBlueButtonMeeting.json");

        String url = zulip.server().createBigBlueButtonVideoCall("Test Meeting").execute();
        assertEquals("https://test.com/test/meeting/url", url);
    }

    @Test
    public void getAllDataExports() throws Exception {
        stubZulipResponse(GET, "/export/realm", Collections.emptyMap(), "getDataExports.json");

        List<DataExport> dataExports = zulip.server().getAllDataExports().execute();
        assertEquals(2, dataExports.size());

        DataExport dataExport = dataExports.get(0);
        assertTrue(dataExport.getExportTime().toEpochMilli() > 0);
        assertNull(dataExport.getDeletedTimestamp());
        assertNull(dataExport.getFailedTimestamp());
        assertEquals("https://test.com/export-1.tar.gz", dataExport.getExportUrl());
        assertEquals(1, dataExport.getActingUserId());
        assertEquals(1, dataExport.getId());
        assertEquals(DataExportType.PUBLIC, dataExport.getExportType());
        assertFalse(dataExport.isPending());

        dataExport = dataExports.get(1);
        assertTrue(dataExport.getExportTime().toEpochMilli() > 0);
        assertTrue(dataExport.getDeletedTimestamp().toEpochMilli() > 0);
        assertTrue(dataExport.getFailedTimestamp().toEpochMilli() > 0);
        assertEquals("https://test.com/export-2.tar.gz", dataExport.getExportUrl());
        assertEquals(2, dataExport.getActingUserId());
        assertEquals(2, dataExport.getId());
        assertEquals(DataExportType.STANDARD, dataExport.getExportType());
        assertTrue(dataExport.isPending());
    }

    @Test
    public void createDataExport() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateDataExportApiRequest.EXPORT_TYPE, "1")
                .get();

        stubZulipResponse(POST, "/export/realm", params, "createDataExport.json");

        Integer id = zulip.server().createDataExport().execute();

        assertEquals(1, id);
    }

    @Test
    public void createDataExportWithExplicitType() throws Exception {
        Map<String, StringValuePattern> params = QueryParams.create()
                .add(CreateDataExportApiRequest.EXPORT_TYPE, "2")
                .get();

        stubZulipResponse(POST, "/export/realm", params, "createDataExport.json");

        Integer id = zulip.server().createDataExport().withExportType(DataExportType.STANDARD).execute();

        assertEquals(1, id);
    }

    @Test
    public void getDataExportConsentState() throws Exception {
        stubZulipResponse(GET, "/export/realm/consents", Collections.emptyMap(), "getDataExportConsents.json");

        List<DataExportConsent> dataExportConsents = zulip.server().getDataExportConsentState().execute();
        assertEquals(2, dataExportConsents.size());
        DataExportConsent dataExportConsent = dataExportConsents.get(0);
        assertEquals(1, dataExportConsent.getUserId());
        assertTrue(dataExportConsent.isConsented());

        dataExportConsent = dataExportConsents.get(1);
        assertEquals(2, dataExportConsent.getUserId());
        assertFalse(dataExportConsent.isConsented());
    }
}

package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.SETTINGS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.MarkReadOnScrollPolicy;
import com.github.jamesnetherton.zulip.client.api.server.RealmNameInNotificationsPolicy;
import com.github.jamesnetherton.zulip.client.api.user.ColorScheme;
import com.github.jamesnetherton.zulip.client.api.user.DemoteInactiveStreamOption;
import com.github.jamesnetherton.zulip.client.api.user.DesktopIconCountDisplay;
import com.github.jamesnetherton.zulip.client.api.user.EmojiSet;
import com.github.jamesnetherton.zulip.client.api.user.UserListStyle;
import com.github.jamesnetherton.zulip.client.api.user.WebAnimateImageOption;
import com.github.jamesnetherton.zulip.client.api.user.WebChannelView;
import com.github.jamesnetherton.zulip.client.api.user.WebHomeView;
import com.github.jamesnetherton.zulip.client.api.user.response.UpdateOwnUserSettingsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for updating own user settings.
 *
 * @see <a href="https://zulip.com/api/update-settings">https://zulip.com/api/update-settings</a>
 */
public class UpdateOwnUserSettingsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<String>> {
    public static final String ALLOW_PRIVATE_DATA_EXPORT = "allow_private_data_export";
    public static final String COLOR_SCHEME = "color_scheme";
    public static final String DEFAULT_LANGUAGE = "default_language";
    public static final String DEFAULT_VIEW = "default_view";
    public static final String DEMOTE_INACTIVE_STREAMS = "demote_inactive_streams";
    public static final String DESKTOP_ICON_COUNT_DISPLAY = "desktop_icon_count_display";
    public static final String DISPLAY_EMOJI_REACTION_USERS = "display_emoji_reaction_users";
    public static final String EMAIL = "email";
    public static final String EMOJISET = "emojiset";
    public static final String ENABLE_DESKTOP_NOTIFICATIONS = "enable_desktop_notifications";
    public static final String ENABLE_DRAFTS_SYNCHRONIZATION = "enable_drafts_synchronization";
    public static final String ENABLE_DIGEST_EMAILS = "enable_digest_emails";
    public static final String ENABLE_LOGIN_EMAILS = "enable_login_emails";
    public static final String EMAIL_NOTIFICATIONS_BATCHING_PERIOD_SECONDS = "email_notifications_batching_period_seconds";
    public static final String ENABLE_MARKETING_EMAILS = "enable_marketing_emails";
    public static final String ENABLE_OFFLINE_EMAIL_NOTIFICATIONS = "enable_offline_email_notifications";
    public static final String ENABLE_OFFLINE_PUSH_NOTIFICATIONS = "enable_offline_push_notifications";
    public static final String ENABLE_ONLINE_PUSH_NOTIFICATIONS = "enable_online_push_notifications";
    public static final String ENABLE_SOUNDS = "enable_sounds";
    public static final String ENABLE_STREAM_DESKTOP_NOTIFICATIONS = "enable_stream_desktop_notifications";
    public static final String ENABLE_STREAM_EMAIL_NOTIFICATIONS = "enable_stream_email_notifications";
    public static final String ENABLE_STREAM_PUSH_NOTIFICATIONS = "enable_stream_push_notifications";
    public static final String ENABLE_STREAM_AUDIBLE_NOTIFICATIONS = "enable_stream_audible_notifications";
    public static final String ENTER_SENDS = "enter_sends";
    public static final String ESCAPE_NAVIGATES_TO_DEFAULT_VIEW = "escape_navigates_to_default_view";
    public static final String FLUID_LAYOUT_WIDTH = "fluid_layout_width";
    public static final String FULL_NAME = "full_name";
    public static final String HIDE_AI_FEATURES = "hide_ai_features";
    public static final String HIGH_CONTRAST_MODE = "high_contrast_mode";
    public static final String LEFT_SIDE_USERLIST = "left_side_userlist";
    public static final String MESSAGE_CONTENT_IN_EMAIL_NOTIFICATIONS = "message_content_in_email_notifications";
    public static final String NEW_PASSWORD = "new_password";
    public static final String NOTIFICATION_SOUND = "notification_sound";
    public static final String OLD_PASSWORD = "old_password";
    public static final String PM_CONTENT_IN_DESKTOP_NOTIFICATIONS = "pm_content_in_desktop_notifications";
    public static final String PRESENCE_ENABLED = "presence_enabled";
    public static final String REALM_NAME_IN_NOTIFICATIONS = "realm_name_in_notifications";
    public static final String REALM_NAME_IN_EMAIL_NOTIFICATIONS_POLICY = "realm_name_in_email_notifications_policy";
    public static final String RECEIVES_TYPING_NOTIFICATIONS = "receives_typing_notifications";
    public static final String SEND_PRIVATE_TYPING_NOTIFICATIONS = "send_private_typing_notifications";
    public static final String SEND_READ_RECEIPTS = "send_read_receipts";
    public static final String SEND_STREAM_TYPING_NOTIFICATIONS = "send_stream_typing_notifications";
    public static final String STARRED_MESSAGE_COUNTS = "starred_message_counts";
    public static final String TIMEZONE = "timezone";
    public static final String TRANSLATE_EMOTICONS = "translate_emoticons";
    public static final String TWENTY_FOUR_HOUR_TIME = "twenty_four_hour_time";
    public static final String USER_LIST_STYLE = "user_list_style";
    public static final String WEB_ANIMATE_IMAGE_PREVIEWS = "web_animate_image_previews";
    public static final String WEB_CHANNEL_DEFAULT_VIEW = "web_channel_default_view";
    public static final String WEB_FONT_SIZE_PX = "web_font_size_px";
    public static final String WEB_LINE_HEIGHT_PERCENT = "web_line_height_percent";
    public static final String WEB_MARK_READ_ON_SCROLL_POLICY = "web_mark_read_on_scroll_policy";
    public static final String WEB_NAVIGATE_TO_SENT_MESSAGE = "web_navigate_to_sent_message";
    public static final String WEB_SUGGEST_UPDATE_TIMEZONE = "web_suggest_update_timezone";
    public static final String WILDCARD_MENTIONS_NOTIFY = "wildcard_mentions_notify";

    /**
     * Constructs a {@link UpdateOwnUserSettingsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public UpdateOwnUserSettingsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets whether organization administrators are allowed to export private data.
     *
     * @param  allowPrivateDataExport {@code true} to allow organization administrators to export private data. {@code false} to
     *                                disallow organization administrators from exporting private data
     * @return                        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withAllowPrivateDataExport(boolean allowPrivateDataExport) {
        putParam(ALLOW_PRIVATE_DATA_EXPORT, allowPrivateDataExport);
        return this;
    }

    /**
     * Sets whether stream desktop notifications should be enabled.
     *
     * @param  colorScheme The color scheme to use
     * @return             This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withColorScheme(ColorScheme colorScheme) {
        putParam(COLOR_SCHEME, colorScheme.getId());
        return this;
    }

    /**
     * Sets the default language to use.
     *
     * @see                 <a href=
     *                      "https://zulip.com/help/change-your-language">https://zulip.com/help/change-your-language</a>
     *
     * @param  languageCode The language code to use. E.g 'en' for English, 'de' for German etc
     * @return              This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withDefaultLanguage(String languageCode) {
        putParam(DEFAULT_LANGUAGE, languageCode);
        return this;
    }

    /**
     * Sets the default view to use.
     *
     * @see                <a href=
     *                     "https://zulip.com/help/configure-default-view">https://zulip.com/help/configure-default-view</a>
     *
     * @param  webHomeView The default view to use
     * @return             This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withDefaultView(WebHomeView webHomeView) {
        putParam(DEFAULT_VIEW, webHomeView.toString());
        return this;
    }

    /**
     * Sets whether to demote inactive streams.
     *
     * @see                               <a href=
     *                                    "https://zulip.com/help/manage-inactive-streams">https://zulip.com/help/manage-inactive-streams</a>
     *
     * @param  demoteInactiveStreamOption The option to control how inactive streams are demoted
     * @return                            This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withDemoteInactiveStreams(DemoteInactiveStreamOption demoteInactiveStreamOption) {
        putParam(DEMOTE_INACTIVE_STREAMS, demoteInactiveStreamOption.getId());
        return this;
    }

    /**
     * Sets whether to display an unread count summary on the Zulip UI.
     *
     * @param  desktopIconCountDisplay The {@link DesktopIconCountDisplay} setting
     * @return                         This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withDesktopIconCountDisplay(DesktopIconCountDisplay desktopIconCountDisplay) {
        putParam(DESKTOP_ICON_COUNT_DISPLAY, desktopIconCountDisplay.getSetting());
        return this;
    }

    /**
     * Sets whether to display the names of reacting users on a message.
     *
     * @param  displayEmojiReactionUsers {@code true} to to display the names of reacting users on a message. {@code false} to
     *                                   not display the names of reacting users on a message
     * @return                           This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withDisplayEmojiReactionUsers(boolean displayEmojiReactionUsers) {
        putParam(DISPLAY_EMOJI_REACTION_USERS, displayEmojiReactionUsers);
        return this;
    }

    /**
     * Sets the duration in seconds for which the Zulip server should wait to batch email notifications before sending them.
     *
     * @param  duration The batching period duration in seconds
     * @return          This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEmailNotificationsBatchingPeriodSeconds(int duration) {
        putParam(EMAIL_NOTIFICATIONS_BATCHING_PERIOD_SECONDS, duration);
        return this;
    }

    /**
     * Asks the Zulip server to initiate a confirmation sequence to change the user email address.
     *
     * @param  email The new email address to switch to
     * @return       This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEmail(String email) {
        putParam(EMAIL, email);
        return this;
    }

    /**
     * The emoji set used to display emoji on the Zulip UI.
     *
     * @param  emojiSet The emoji set to use
     * @return          This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEmojiSet(EmojiSet emojiSet) {
        putParam(EMOJISET, emojiSet.toString());
        return this;
    }

    /**
     * Sets whether desktop notifications are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableDesktopNotifications(boolean enable) {
        putParam(ENABLE_DESKTOP_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether digest emails are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableDigestEmails(boolean enable) {
        putParam(ENABLE_DIGEST_EMAILS, enable);
        return this;
    }

    /**
     * Sets whether synchronizing drafts is enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableDraftsSynchronization(boolean enable) {
        putParam(ENABLE_DRAFTS_SYNCHRONIZATION, enable);
        return this;
    }

    /**
     * Sets whether login emails are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableLoginEmails(boolean enable) {
        putParam(ENABLE_LOGIN_EMAILS, enable);
        return this;
    }

    /**
     * Sets whether to enable marketing emails.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableMarketingEmails(boolean enable) {
        putParam(ENABLE_MARKETING_EMAILS, enable);
        return this;
    }

    /**
     * Sets whether offline email notifications are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableOfflineEmailNotifications(boolean enable) {
        putParam(ENABLE_OFFLINE_EMAIL_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether offline push notifications are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableOfflinePushNotifications(boolean enable) {
        putParam(ENABLE_OFFLINE_PUSH_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether online push notifications are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableOnlinePushNotifications(boolean enable) {
        putParam(ENABLE_ONLINE_PUSH_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether sounds are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableSounds(boolean enable) {
        putParam(ENABLE_SOUNDS, enable);
        return this;
    }

    /**
     * Sets whether stream audible notifications should be enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableStreamAudibleNotifications(boolean enable) {
        putParam(ENABLE_STREAM_AUDIBLE_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether stream desktop notifications should be enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableStreamDesktopNotifications(boolean enable) {
        putParam(ENABLE_STREAM_DESKTOP_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether stream email notifications should be enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableStreamEmailNotifications(boolean enable) {
        putParam(ENABLE_STREAM_EMAIL_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether stream push notifications should be enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnableStreamPushNotifications(boolean enable) {
        putParam(ENABLE_STREAM_PUSH_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether pressing the enter key on the Zulip UI sends a message.
     *
     * @param  enterSends {@code true} causes the enter key press to send the message. {@code false} does not send a message
     *                    when the enter key is pressed
     * @return            This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEnterSends(boolean enterSends) {
        putParam(ENTER_SENDS, enterSends);
        return this;
    }

    /**
     * Sets whether pressing the escape key navigates to the default view.
     *
     * @see                                 <a href=
     *                                      "https://zulip.com/help/configure-default-view">https://zulip.com/help/configure-default-view</a>
     *
     * @param  escapeNavigatesToDefaultView {@code true} causes the escape key press to navigate to the default view.
     *                                      {@code false} the default view is not navigated to when the escape key is pressed
     * @return                              This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withEscapeNavigatesToDefaultView(boolean escapeNavigatesToDefaultView) {
        putParam(ESCAPE_NAVIGATES_TO_DEFAULT_VIEW, escapeNavigatesToDefaultView);
        return this;
    }

    /**
     * Whether to use the maximum available screen width for the Zulip web UI center panel.
     *
     * @param  fluidLayoutWidth {@code true} causes the Zulip UI to use the maximum available screen width for the center panel.
     *                          {@code false} causes the UI to not use the maximum available width for the UI center panel
     * @return                  This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withFluidLayoutWidth(boolean fluidLayoutWidth) {
        putParam(FLUID_LAYOUT_WIDTH, fluidLayoutWidth);
        return this;
    }

    /**
     * Sets a new display name for the user.
     *
     * @param  fullName {@code true} The new display name.
     * @return          This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withFullName(String fullName) {
        putParam(FULL_NAME, fullName);
        return this;
    }

    /**
     * Sets whether AI features like topic summarization should be hidden.
     *
     * @param  hideAiFeatures {@code true} to hide AI features. {@code false} to not hide AI features.
     * @return                This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withHideAiFeatures(boolean hideAiFeatures) {
        putParam(HIDE_AI_FEATURES, hideAiFeatures);
        return this;
    }

    /**
     * Whether to enable variations in the Zulip UI to help visually impaired users.
     *
     * @param  highContrastMode {@code true} enables high contrast mode. {@code false} disables high contrast mode
     * @return                  This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withHighContrastMode(boolean highContrastMode) {
        putParam(HIGH_CONTRAST_MODE, highContrastMode);
        return this;
    }

    /**
     * Whether the users list on left sidebar in narrow windows.
     *
     * @param  leftSideUserList {@code true} makes the users list appear on the left side bar in the Zulip web UI. {@code false}
     *                          places the users list elsewhere in the Web UI
     * @return                  This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withLeftSideUserList(boolean leftSideUserList) {
        putParam(LEFT_SIDE_USERLIST, leftSideUserList);
        return this;
    }

    /**
     * Sets whether message content is present in email notifications.
     *
     * @param  messageContentInEmailNotifications {@code true} to show message content in email notifications. {@code false} to
     *                                            not show message content in email notifications
     * @return                                    This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withMessageContentInEmailNotifications(
            boolean messageContentInEmailNotifications) {
        putParam(MESSAGE_CONTENT_IN_EMAIL_NOTIFICATIONS, messageContentInEmailNotifications);
        return this;
    }

    /**
     * The new password for the current user. Must be set in conjunction with
     * {@link UpdateOwnUserSettingsApiRequest#withOldPassword(String)} ()}
     *
     * @param  newPassword the new password
     * @return             This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withNewPassword(String newPassword) {
        putParam(NEW_PASSWORD, newPassword);
        return this;
    }

    /**
     * Sets the notification sound.
     *
     * @param  notificationSound The name of the notification sound to play
     * @return                   This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withNotificationSound(String notificationSound) {
        putParam(NOTIFICATION_SOUND, notificationSound);
        return this;
    }

    /**
     * The old password for the current user. Must be set in conjunction with
     * {@link UpdateOwnUserSettingsApiRequest#withNewPassword(String)} ()}
     *
     * @param  oldPassword the old password
     * @return             This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withOldPassword(String oldPassword) {
        putParam(OLD_PASSWORD, oldPassword);
        return this;
    }

    /**
     * Sets whether private message content shows in desktop notifications.
     *
     * @param  pmContentInDesktopNotifications {@code true} to have private message content show in desktop notifications.
     *                                         {@code false} to not have private message content show in desktop notifications
     * @return                                 This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withPmContentInDesktopNotifications(boolean pmContentInDesktopNotifications) {
        putParam(PM_CONTENT_IN_DESKTOP_NOTIFICATIONS, pmContentInDesktopNotifications);
        return this;
    }

    /**
     * Sets whether to display the presence status to other users when online.
     *
     * @param  enable {@code true} to display the presence status to other users when online. {@code false} to not display the
     *                presence status to other users when online
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withPresenceEnabled(boolean enable) {
        putParam(PRESENCE_ENABLED, enable);
        return this;
    }

    /**
     * Sets whether to include organization name in subject of missed message emails.
     *
     * @param      realmNameInNotifications {@code true} to include the organization name in the subject of missed message
     *                                      emails.
     *                                      {@code false} to not include the organization name in the subject of missed message
     *                                      emails
     * @return                              This {@link UpdateOwnUserSettingsApiRequest} instance
     * @deprecated                          Use withRealmNameInEmailNotifications instead
     */
    @Deprecated
    public UpdateOwnUserSettingsApiRequest withRealmNameInNotifications(boolean realmNameInNotifications) {
        putParam(REALM_NAME_IN_NOTIFICATIONS, realmNameInNotifications);
        return this;
    }

    /**
     * Sets whether to include the organization name in the subject of message notification emails.
     *
     * @param  policy The {@link RealmNameInNotificationsPolicy} to determine whether to include the organization name in the
     *                subject of message notification emails
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withRealmNameInEmailNotifications(RealmNameInNotificationsPolicy policy) {
        putParam(REALM_NAME_IN_EMAIL_NOTIFICATIONS_POLICY, policy.getId());
        return this;
    }

    /**
     * Sets whether the user is configured to receive typing notifications from other users.
     *
     * @param  receivesTypingNotifications {@code} true to receive typing notifications from other users. {@code false} to not
     *                                     receive typing notifications from other users.
     * @return                             This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withReceivesTypingNotifications(boolean receivesTypingNotifications) {
        putParam(RECEIVES_TYPING_NOTIFICATIONS, receivesTypingNotifications);
        return this;
    }

    /**
     * Sets whether typing notifications be sent when composing private messages.
     *
     * @see                                   <a href=
     *                                        "https://zulip.com/help/status-and-availability#typing-notifications">https://zulip.com/help/status-and-availability#typing-notifications</a>
     *
     * @param  sendPrivateTypingNotifications {@code true} to send typing notifications. {@code false} to not send typing
     *                                        notifications
     * @return                                This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withSendPrivateTypingNotifications(boolean sendPrivateTypingNotifications) {
        putParam(SEND_PRIVATE_TYPING_NOTIFICATIONS, sendPrivateTypingNotifications);
        return this;
    }

    /**
     * Sets whether other users are allowed to see whether you have read messages.
     *
     * @param  sendReadReceipts {@code true} to allow others see whether you have read messages. {@code false} to disallow users
     *                          seeing whether you have read messages
     * @return                  This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withSendReadReceipts(boolean sendReadReceipts) {
        putParam(SEND_READ_RECEIPTS, sendReadReceipts);
        return this;
    }

    /**
     * Sets whether typing notifications be sent when composing stream messages.
     *
     * @see                                  <a href=
     *                                       "https://zulip.com/help/status-and-availability#typing-notifications">https://zulip.com/help/status-and-availability#typing-notifications</a>
     *
     * @param  sendStreamTypingNotifications {@code true} to send typing notifications. {@code false} to not send typing
     *                                       notifications
     * @return                               This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withSendStreamTypingNotifications(boolean sendStreamTypingNotifications) {
        putParam(SEND_STREAM_TYPING_NOTIFICATIONS, sendStreamTypingNotifications);
        return this;
    }

    /**
     * Sets whether to display the number of starred messages.
     *
     * @see                         <a href=
     *                              "https://zulip.com/help/star-a-message#display-the-number-of-starred-messages">https://zulip.com/help/star-a-message#display-the-number-of-starred-messages</a>
     *
     * @param  starredMessageCounts {@code true} to display the number of starred messages. {@code false} to not display the
     *                              number of starred messages
     * @return                      This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withStarredMessageCounts(boolean starredMessageCounts) {
        putParam(STARRED_MESSAGE_COUNTS, starredMessageCounts);
        return this;
    }

    /**
     * Sets the user configured timezone.
     *
     * @see             <a href="https://zulip.com/help/change-your-timezone">https://zulip.com/help/change-your-timezone</a>
     * @see             <a href=
     *                  "https://zulip.com/static/generated/timezones.json">https://zulip.com/static/generated/timezones.json</a>
     *
     * @param  timezone The users timezone
     * @return          This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withTimezone(String timezone) {
        putParam(TIMEZONE, timezone);
        return this;
    }

    /**
     * Sets whether to translate emoticons to emoji in messages the user sends.
     *
     * @see                       <a href=
     *                            "https://zulip.com/help/enable-emoticon-translations">https://zulip.com/help/enable-emoticon-translations</a>
     *
     * @param  translateEmoticons {@code true} to translate emoticons to emoji. {@code false} to not translate emoticons
     * @return                    This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withTranslateEmoticons(boolean translateEmoticons) {
        putParam(TRANSLATE_EMOTICONS, translateEmoticons);
        return this;
    }

    /**
     * Sets whether time should be displayed in 24-hour notation.
     *
     * @see           <a href="https://zulip.com/help/change-the-time-format">https://zulip.com/help/change-the-time-format</a>
     *
     * @param  enable {@code true} to display the time in 24-hour notation. {@code false} to not display time in 24-hour
     *                notation
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withTwentyFourHourTime(boolean enable) {
        putParam(TWENTY_FOUR_HOUR_TIME, enable);
        return this;
    }

    /**
     * Sets the style selected by the user for the right sidebar user list.
     *
     * @param  userListStyle for the style selected by the user for the right sidebar user list
     * @return               This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withUserListStyle(UserListStyle userListStyle) {
        putParam(USER_LIST_STYLE, userListStyle.getId());
        return this;
    }

    /**
     * Sets how animated images should be played in the message feed.
     *
     * @param  webAnimateImageOption The option determining how animated images should be played
     * @return                       This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withWebAnimateImagePreviews(WebAnimateImageOption webAnimateImageOption) {
        putParam(WEB_ANIMATE_IMAGE_PREVIEWS, webAnimateImageOption.toString());
        return this;
    }

    /**
     * Sets the default navigation behavior when clicking on a channel link.
     *
     * @param  webChannelView for the default channel view
     * @return                This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withWebChannelDefaultView(WebChannelView webChannelView) {
        putParam(WEB_CHANNEL_DEFAULT_VIEW, webChannelView.getId());
        return this;
    }

    /**
     * Sets the user primary font size in pixels.
     *
     * @param  fontSize The size of the font used on the Zulip web UI
     * @return          This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withWebFontPx(int fontSize) {
        putParam(WEB_FONT_SIZE_PX, fontSize);
        return this;
    }

    /**
     * Sets the user primary line height for the Zulip web UI in percent.
     *
     * @param  webLineHeightPercent The line height percentage value
     * @return                      This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withWebLineHeightPercent(int webLineHeightPercent) {
        putParam(WEB_LINE_HEIGHT_PERCENT, webLineHeightPercent);
        return this;
    }

    /**
     * Sets whether to mark messages as read when the user scrolls through their feed.
     *
     * @param  policy The {@link MarkReadOnScrollPolicy} to determine whether when messages are marked as read
     * @return        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withWebMarkReadOnScrollPolicy(MarkReadOnScrollPolicy policy) {
        putParam(WEB_MARK_READ_ON_SCROLL_POLICY, policy.getId());
        return this;
    }

    /**
     * Sets whether the user view should automatically go to the conversation where they sent a message.
     *
     * @param  webNavigateToSentMessage {@code true} to automatically go to the conversation where they sent a message.
     *                                  {@code false} to not automatically go to the conversation where they sent a message.
     * @return                          This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withWebNavigateToSentMessage(boolean webNavigateToSentMessage) {
        putParam(WEB_NAVIGATE_TO_SENT_MESSAGE, webNavigateToSentMessage);
        return this;
    }

    /**
     * Sets whether the user should be shown an alert, offering to update their profile time zone, when the time displayed for
     * the profile time zone differs from the current time displayed by the time zone configured on their device.
     *
     * @param  webSuggestUpdateTimezone {@code true} to show a user alert offering to update their profile time zone.
     *                                  {@code} false to not show an alert.
     * @return                          This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withWebSuggestUpdateTimezone(boolean webSuggestUpdateTimezone) {
        putParam(WEB_SUGGEST_UPDATE_TIMEZONE, webSuggestUpdateTimezone);
        return this;
    }

    /**
     * Sets whether to be notified when wildcard mentions are triggered.
     *
     * @param  wildcardMentionsNotify {@code true} to be notified when wildcard mentions are triggered. {@code false} to not be
     *                                notified when wildcard mentions are triggered
     * @return                        This {@link UpdateOwnUserSettingsApiRequest} instance
     */
    public UpdateOwnUserSettingsApiRequest withWildcardMentionsNotify(boolean wildcardMentionsNotify) {
        putParam(WILDCARD_MENTIONS_NOTIFY, wildcardMentionsNotify);
        return this;
    }

    /**
     * Executes the Zulip API request for updating own user settings.
     *
     * @return                      List of settings that were ignored
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<String> execute() throws ZulipClientException {
        UpdateOwnUserSettingsApiResponse result = client().patch(SETTINGS, getParams(), UpdateOwnUserSettingsApiResponse.class);
        return result.getIgnoredParametersUnsupported();
    }
}

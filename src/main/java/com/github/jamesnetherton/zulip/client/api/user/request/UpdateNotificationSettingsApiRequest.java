package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.SETTINGS_NOTIFICATIONS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.DesktopIconCountDisplay;
import com.github.jamesnetherton.zulip.client.api.user.response.UpdateNotificationSettingsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Map;

/**
 * Zulip API request builder for updating user notification settings.
 *
 * @see <a href="https://zulip.com/api/update-notification-settings">https://zulip.com/api/update-notification-settings</a>
 */
@Deprecated
public class UpdateNotificationSettingsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Map<String, Object>> {

    public static final String ENABLE_STREAM_DESKTOP_NOTIFICATIONS = "enable_stream_desktop_notifications";
    public static final String ENABLE_STREAM_EMAIL_NOTIFICATIONS = "enable_stream_email_notifications";
    public static final String ENABLE_STREAM_PUSH_NOTIFICATIONS = "enable_stream_push_notifications";
    public static final String ENABLE_STREAM_AUDIBLE_NOTIFICATIONS = "enable_stream_audible_notifications";
    public static final String NOTIFICATION_SOUND = "notification_sound";
    public static final String ENABLE_DESKTOP_NOTIFICATIONS = "enable_desktop_notifications";
    public static final String ENABLE_SOUNDS = "enable_sounds";
    public static final String ENABLE_OFFLINE_EMAIL_NOTIFICATIONS = "enable_offline_email_notifications";
    public static final String ENABLE_OFFLINE_PUSH_NOTIFICATIONS = "enable_offline_push_notifications";
    public static final String ENABLE_ONLINE_PUSH_NOTIFICATIONS = "enable_online_push_notifications";
    public static final String ENABLE_DIGEST_EMAILS = "enable_digest_emails";
    public static final String ENABLE_LOGIN_EMAILS = "enable_login_emails";
    public static final String MESSAGE_CONTENT_IN_EMAIL_NOTIFICATIONS = "message_content_in_email_notifications";
    public static final String PM_CONTENT_IN_DESKTOP_NOTIFICATIONS = "pm_content_in_desktop_notifications";
    public static final String WILDCARD_MENTIONS_NOTIFY = "wildcard_mentions_notify";
    public static final String DESKTOP_ICON_COUNT_DISPLAY = "desktop_icon_count_display";
    public static final String REALM_NAME_IN_NOTIFICATIONS = "realm_name_in_notifications";
    public static final String PRESENCE_ENABLED = "presence_enabled";

    /**
     * Constructs a {@link UpdateNotificationSettingsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public UpdateNotificationSettingsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets whether stream desktop notifications should be enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableStreamDesktopNotifications(boolean enable) {
        putParam(ENABLE_STREAM_DESKTOP_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether stream email notifications should be enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableStreamEmailNotifications(boolean enable) {
        putParam(ENABLE_STREAM_EMAIL_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether stream push notifications should be enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableStreamPushNotifications(boolean enable) {
        putParam(ENABLE_STREAM_PUSH_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether stream audible notifications should be enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableStreamAudibleNotifications(boolean enable) {
        putParam(ENABLE_STREAM_AUDIBLE_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets the notification sound
     *
     * @param  notificationSound The name of the notification sound to play
     * @return                   This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withNotificationSound(String notificationSound) {
        putParam(NOTIFICATION_SOUND, notificationSound);
        return this;
    }

    /**
     * Sets whether desktop notifications are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableDesktopNotifications(boolean enable) {
        putParam(ENABLE_DESKTOP_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether sounds are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableSounds(boolean enable) {
        putParam(ENABLE_SOUNDS, enable);
        return this;
    }

    /**
     * Sets whether offline email notifications are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableOfflineEmailNotifications(boolean enable) {
        putParam(ENABLE_OFFLINE_EMAIL_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether offline push notifications are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableOfflinePushNotifications(boolean enable) {
        putParam(ENABLE_OFFLINE_PUSH_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether online push notifications are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableOnlinePushNotifications(boolean enable) {
        putParam(ENABLE_ONLINE_PUSH_NOTIFICATIONS, enable);
        return this;
    }

    /**
     * Sets whether digest emails are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableDigestEmails(boolean enable) {
        putParam(ENABLE_DIGEST_EMAILS, enable);
        return this;
    }

    /**
     * Sets whether login emails are enabled.
     *
     * @param  enable {@code true} to enable. {@code false} to disable
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withEnableLoginEmails(boolean enable) {
        putParam(ENABLE_LOGIN_EMAILS, enable);
        return this;
    }

    /**
     * Sets whether message content is present in email notifications.
     *
     * @param  messageContentInEmailNotifications {@code true} to show message content in email notifications. {@code false} to
     *                                            not show message content in email notifications
     * @return                                    This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withMessageContentInEmailNotifications(
            boolean messageContentInEmailNotifications) {
        putParam(MESSAGE_CONTENT_IN_EMAIL_NOTIFICATIONS, messageContentInEmailNotifications);
        return this;
    }

    /**
     * Sets whether private message content shows in desktop notifications.
     *
     * @param  pmContentInDesktopNotifications {@code true} to have private message content show in desktop notifications.
     *                                         {@code false} to not have private message content show in desktop notifications
     * @return                                 This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withPmContentInDesktopNotifications(boolean pmContentInDesktopNotifications) {
        putParam(PM_CONTENT_IN_DESKTOP_NOTIFICATIONS, pmContentInDesktopNotifications);
        return this;
    }

    /**
     * Sets whether to be notified when wildcard mentions are triggered.
     *
     * @param  wildcardMentionsNotify {@code true} to be notified when wildcard mentions are triggered. {@code false} to not be
     *                                notified when wildcard mentions are triggered
     * @return                        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withWildcardMentionsNotify(boolean wildcardMentionsNotify) {
        putParam(WILDCARD_MENTIONS_NOTIFY, wildcardMentionsNotify);
        return this;
    }

    /**
     * Sets whether to display an unread count summary on the Zulip UI.
     *
     * @param  desktopIconCountDisplay The {@link DesktopIconCountDisplay} setting
     * @return                         This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withDesktopIconCountDisplay(DesktopIconCountDisplay desktopIconCountDisplay) {
        putParam(DESKTOP_ICON_COUNT_DISPLAY, desktopIconCountDisplay.getSetting());
        return this;
    }

    /**
     * Sets whether to include organization name in subject of missed message emails.
     *
     * @param  realmNameInNotifications {@code true} to include the organization name in the subject of missed message emails.
     *                                  {@code false} to not include the organization name in the subject of missed message
     *                                  emails
     * @return                          This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withRealmNameInNotifications(boolean realmNameInNotifications) {
        putParam(REALM_NAME_IN_NOTIFICATIONS, realmNameInNotifications);
        return this;
    }

    /**
     * Sets whether to display the presence status to other users when online.
     *
     * @param  enable {@code true} to display the presence status to other users when online. {@code false} to not display the
     *                presence status to other users when online
     * @return        This {@link UpdateNotificationSettingsApiRequest} instance
     */
    public UpdateNotificationSettingsApiRequest withPresenceEnabled(boolean enable) {
        putParam(PRESENCE_ENABLED, enable);
        return this;
    }

    /**
     * Executes the Zulip API request for updating user notification settings.
     *
     * @return                      Map of updated user notification settings
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Map<String, Object> execute() throws ZulipClientException {
        UpdateNotificationSettingsApiResponse response = client().patch(SETTINGS_NOTIFICATIONS, getParams(),
                UpdateNotificationSettingsApiResponse.class);
        return response.getSettings();
    }
}

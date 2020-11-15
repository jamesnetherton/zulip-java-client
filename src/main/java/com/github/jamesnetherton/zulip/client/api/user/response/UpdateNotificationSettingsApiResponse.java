package com.github.jamesnetherton.zulip.client.api.user.response;

import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.DESKTOP_ICON_COUNT_DISPLAY;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_DESKTOP_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_DIGEST_EMAILS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_LOGIN_EMAILS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_OFFLINE_EMAIL_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_OFFLINE_PUSH_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_ONLINE_PUSH_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_SOUNDS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_STREAM_AUDIBLE_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_STREAM_DESKTOP_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_STREAM_EMAIL_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.ENABLE_STREAM_PUSH_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.MESSAGE_CONTENT_IN_EMAIL_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.NOTIFICATION_SOUND;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.PM_CONTENT_IN_DESKTOP_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.PRESENCE_ENABLED;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.REALM_NAME_IN_NOTIFICATIONS;
import static com.github.jamesnetherton.zulip.client.api.user.request.UpdateNotificationSettingsApiRequest.WILDCARD_MENTIONS_NOTIFY;

import com.fasterxml.jackson.annotation.JsonSetter;
import com.fasterxml.jackson.databind.JsonNode;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.DesktopIconCountDisplay;
import java.util.HashMap;
import java.util.Map;

/**
 * Zulip API response class for updating user notification settings.
 *
 * @see <a href=
 *      "https://zulip.com/api/update-notification-settings#response">https://zulip.com/api/update-notification-settings#response</a>
 */
public class UpdateNotificationSettingsApiResponse extends ZulipApiResponse {

    private final Map<String, Object> settings = new HashMap<>();

    public Map<String, Object> getSettings() {
        return this.settings;
    }

    @JsonSetter
    public void setEnableStreamDesktopNotifications(JsonNode node) {
        addSetting(ENABLE_STREAM_DESKTOP_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setEnableStreamEmailNotifications(JsonNode node) {
        addSetting(ENABLE_STREAM_EMAIL_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setEnableStreamPushNotifications(JsonNode node) {
        addSetting(ENABLE_STREAM_PUSH_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setEnableStreamAudibleNotifications(JsonNode node) {
        addSetting(ENABLE_STREAM_AUDIBLE_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setNotificationSound(JsonNode node) {
        addSetting(NOTIFICATION_SOUND, node);
    }

    @JsonSetter
    public void setEnableDesktopNotifications(JsonNode node) {
        addSetting(ENABLE_DESKTOP_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setEnableSounds(JsonNode node) {
        addSetting(ENABLE_SOUNDS, node);
    }

    @JsonSetter
    public void setEnableOfflineEmailNotifications(JsonNode node) {
        addSetting(ENABLE_OFFLINE_EMAIL_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setEnableOfflinePushNotifications(JsonNode node) {
        addSetting(ENABLE_OFFLINE_PUSH_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setEnableOnlinePushNotifications(JsonNode node) {
        addSetting(ENABLE_ONLINE_PUSH_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setEnableDigestEmails(JsonNode node) {
        addSetting(ENABLE_DIGEST_EMAILS, node);
    }

    @JsonSetter
    public void setEnableLoginEmails(JsonNode node) {
        addSetting(ENABLE_LOGIN_EMAILS, node);
    }

    @JsonSetter
    public void setMessageContentInEmailNotifications(JsonNode node) {
        addSetting(MESSAGE_CONTENT_IN_EMAIL_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setPmContentInDesktopNotifications(JsonNode node) {
        addSetting(PM_CONTENT_IN_DESKTOP_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setWildcardMentionsNotify(JsonNode node) {
        addSetting(WILDCARD_MENTIONS_NOTIFY, node);
    }

    @JsonSetter
    public void setDesktopIconCountDisplay(JsonNode node) {
        addSetting(DESKTOP_ICON_COUNT_DISPLAY, node);
    }

    @JsonSetter
    public void setRealmNameInNotifications(JsonNode node) {
        addSetting(REALM_NAME_IN_NOTIFICATIONS, node);
    }

    @JsonSetter
    public void setPresenceEnabled(JsonNode node) {
        addSetting(PRESENCE_ENABLED, node);
    }

    private void addSetting(String key, JsonNode node) {
        if (node.isBoolean()) {
            settings.put(key, node.asBoolean());
        } else if (node.isTextual()) {
            settings.put(key, node.asText());
        } else if (node.isNumber()) {
            settings.put(key, DesktopIconCountDisplay.fromInt(node.asInt()));
        }
    }
}

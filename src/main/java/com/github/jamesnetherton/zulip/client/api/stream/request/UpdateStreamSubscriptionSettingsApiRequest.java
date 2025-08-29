package com.github.jamesnetherton.zulip.client.api.stream.request;

import static com.github.jamesnetherton.zulip.client.api.stream.request.StreamRequestConstants.SUBSCRIPTIONS_PROPERTIES;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.stream.StreamSubscriptionSetting;
import com.github.jamesnetherton.zulip.client.api.stream.response.UpdateStreamSubscriptionSettingsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * Zulip API request builder for updating stream subscription settings.
 *
 * @see <a href="https://zulip.com/api/update-subscription-settings">https://zulip.com/api/update-subscription-settings</a>
 */
public class UpdateStreamSubscriptionSettingsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<String>> {

    public static final String COLOR = "color";
    public static final String IS_MUTED = "is_muted";
    public static final String PIN_TO_TOP = "pin_to_top";
    public static final String DESKTOP_NOTIFICATIONS = "desktop_notifications";
    public static final String AUDIBLE_NOTIFICATIONS = "audible_notifications";
    public static final String PUSH_NOTIFICATIONS = "push_notifications";
    public static final String EMAIL_NOTIFICATIONS = "email_notifications";
    public static final String WILDCARD_MENTIONS_NOTIFY = "wildcard_mentions_notify";
    public static final String SUBSCRIPTION_DATA = "subscription_data";

    private final Set<StreamSubscriptionSetting> settings = new LinkedHashSet<>();

    /**
     * Constructs a {@link UpdateStreamSubscriptionSettingsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public UpdateStreamSubscriptionSettingsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets the hex value of the color to display on the Zulip UI.
     *
     * @param  streamId The id of the stream for which the setting should be updated
     * @param  color    The hex value of the color
     * @return          This {@link UpdateStreamSubscriptionSettingsApiRequest} instance
     */
    public UpdateStreamSubscriptionSettingsApiRequest withColor(long streamId, String color) {
        addSetting(streamId, COLOR, color);
        return this;
    }

    /**
     * Sets whether the stream should be muted.
     *
     * @param  streamId The id of the stream for which the setting should be updated
     * @param  muted    {@code true} to mute the stream. {@code false} to unmute the stream
     * @return          This {@link UpdateStreamSubscriptionSettingsApiRequest} instance
     */
    public UpdateStreamSubscriptionSettingsApiRequest withIsMuted(long streamId, boolean muted) {
        addSetting(streamId, IS_MUTED, muted);
        return this;
    }

    /**
     * Sets whether the stream should be pinned to the top in the Zulip UI.
     *
     * @param  streamId The id of the stream for which the setting should be updated
     * @param  pinToTop {@code true} to pin the stream to top. {@code false} to unpin the stream
     * @return          This {@link UpdateStreamSubscriptionSettingsApiRequest} instance
     */
    public UpdateStreamSubscriptionSettingsApiRequest withPinToTop(long streamId, boolean pinToTop) {
        addSetting(streamId, PIN_TO_TOP, pinToTop);
        return this;
    }

    /**
     * Sets whether to show desktop notifications for messages sent to the stream.
     *
     * @param  streamId             The id of the stream for which the setting should be updated
     * @param  desktopNotifications {@code true} to enable desktop notifications. {@code false} to disable desktop
     *                              notifications.
     * @return                      This {@link UpdateStreamSubscriptionSettingsApiRequest} instance
     */
    public UpdateStreamSubscriptionSettingsApiRequest withDesktopNotifications(long streamId, boolean desktopNotifications) {
        addSetting(streamId, DESKTOP_NOTIFICATIONS, desktopNotifications);
        return this;
    }

    /**
     * Sets whether to play a sound for messages sent to the stream.
     *
     * @param  streamId             The id of the stream for which the setting should be updated
     * @param  audibleNotifications {@code true} to enable audible notifications. {@code false} to disable audible
     *                              notifications.
     * @return                      This {@link UpdateStreamSubscriptionSettingsApiRequest} instance
     */
    public UpdateStreamSubscriptionSettingsApiRequest withAudibleNotifications(long streamId, boolean audibleNotifications) {
        addSetting(streamId, AUDIBLE_NOTIFICATIONS, audibleNotifications);
        return this;
    }

    /**
     * Sets whether to enable or disable push notifications a sound for messages sent to the stream.
     *
     * @param  streamId          The id of the stream for which the setting should be updated
     * @param  pushNotifications {@code true} to enable mobile push notifications. {@code false} to disable mobile push
     *                           notifications.
     * @return                   This {@link UpdateStreamSubscriptionSettingsApiRequest} instance
     */
    public UpdateStreamSubscriptionSettingsApiRequest withPushNotifications(long streamId, boolean pushNotifications) {
        addSetting(streamId, PUSH_NOTIFICATIONS, pushNotifications);
        return this;
    }

    /**
     * Sets whether to enable or disable email notifications a sound for messages sent to the stream.
     *
     * @param  streamId           The id of the stream for which the setting should be updated
     * @param  emailNotifications {@code true} to enable email notifications. {@code false} to disable email notifications.
     * @return                    This {@link UpdateStreamSubscriptionSettingsApiRequest} instance
     */
    public UpdateStreamSubscriptionSettingsApiRequest withEmailNotifications(long streamId, boolean emailNotifications) {
        addSetting(streamId, EMAIL_NOTIFICATIONS, emailNotifications);
        return this;
    }

    /**
     * Sets whether to enable or disable wildcard mentions trigger notifications for messages sent to the stream.
     *
     * @param  streamId               The id of the stream for which the setting should be updated
     * @param  wildcardMentionsNotify {@code true} to enable wildcard mentions trigger notifications. {@code false} to disable
     *                                email notifications.
     * @return                        This {@link UpdateStreamSubscriptionSettingsApiRequest} instance
     */
    public UpdateStreamSubscriptionSettingsApiRequest withWildcardMentionsNotify(long streamId,
            boolean wildcardMentionsNotify) {
        addSetting(streamId, WILDCARD_MENTIONS_NOTIFY, wildcardMentionsNotify);
        return this;
    }

    private void addSetting(long streamId, String property, Object value) {
        StreamSubscriptionSetting setting = new StreamSubscriptionSetting(streamId, property, value);
        settings.remove(setting);
        settings.add(setting);
    }

    /**
     * Executes the Zulip API request for updating stream subscription settings.
     *
     * @return                      List of modified settings encapsulated by {@link StreamSubscriptionSetting}
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<String> execute() throws ZulipClientException {
        putParamAsJsonString(SUBSCRIPTION_DATA, settings);

        UpdateStreamSubscriptionSettingsApiResponse response = client().post(SUBSCRIPTIONS_PROPERTIES, getParams(),
                UpdateStreamSubscriptionSettingsApiResponse.class);
        return response.getIgnoredParametersUnsupported();
    }
}

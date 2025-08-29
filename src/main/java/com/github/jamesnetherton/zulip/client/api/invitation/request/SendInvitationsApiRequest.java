package com.github.jamesnetherton.zulip.client.api.invitation.request;

import static com.github.jamesnetherton.zulip.client.api.invitation.request.InvitationRequestConstants.INVITATIONS_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserRole;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for sending user invitations.
 *
 * @see <a href="https://zulip.com/api/send-invites">https://zulip.com/api/send-invites</a>
 */
public class SendInvitationsApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String GROUP_IDS = "group_ids";
    public static final String INCLUDE_REALM_DEFAULT_SUBSCRIPTIONS = "include_realm_default_subscriptions";
    public static final String INVITEE_EMAILS = "invitee_emails";
    public static final String INVITE_AS = "invite_as";
    public static final String INVITE_EXPIRES_IN_MINUTES = "invite_expires_in_minutes";
    public static final String NOTIFIY_REFERRER_ON_JOIN = "notify_referrer_on_join";
    public static final String STREAM_IDS = "stream_ids";
    public static final String WELCOME_MESSAGE_CUSTOM_TEXT = "welcome_message_custom_text";

    /**
     * Constructs a {@link SendInvitationsApiRequest}.
     *
     * @param client        The Zulip HTTP client
     * @param inviteeEmails The list of email addresses to invite
     * @param streamIds     The list of channel ids that the newly created user will be automatically subscribed to
     */
    public SendInvitationsApiRequest(ZulipHttpClient client, List<String> inviteeEmails, List<Long> streamIds) {
        super(client);
        putParam(INVITEE_EMAILS, String.join(",", inviteeEmails));
        putParamAsJsonString(STREAM_IDS, streamIds.toArray(new Long[0]));
    }

    /**
     * Sets the ids of groups that the user should be added to upon accepting the invitation.
     *
     * @param  groupIds The ids of the invited user should be added to
     * @return          This {@link SendInvitationsApiRequest} instance
     */
    public SendInvitationsApiRequest withGroupIds(long... groupIds) {
        putParamAsJsonString(GROUP_IDS, groupIds);
        return this;
    }

    /**
     * Sets whether the newly created user should be subscribed to the default channels for the organization.
     *
     * @see                                     <a href=
     *                                          "https://zulip.com/api/send-invites#parameter-include_realm_default_subscriptions">https://zulip.com/api/send-invites#parameter-include_realm_default_subscriptions</a>
     *
     * @param  includeRealmDefaultSubscriptions When {@code true}, the newly created user will be subscribed to the default
     *                                          channels for the organization. When {@code false} the user is not subscribed to
     *                                          any default channels.
     * @return                                  This {@link SendInvitationsApiRequest} instance
     */
    public SendInvitationsApiRequest withIncludeRealmDefaultSubscriptions(boolean includeRealmDefaultSubscriptions) {
        putParam(INCLUDE_REALM_DEFAULT_SUBSCRIPTIONS, includeRealmDefaultSubscriptions);
        return this;
    }

    /**
     * Sets the organization level role of the user that is created when the invitation is accepted.
     *
     * @see         <a href=
     *              "https://zulip.com/api/send-invites#parameter-invite_as">https://zulip.com/api/send-invites#parameter-invite_as</a>
     *
     * @param  role The {@link UserRole} that should apply to the new user
     * @return      This {@link SendInvitationsApiRequest} instance
     */
    public SendInvitationsApiRequest withInviteAs(UserRole role) {
        putParam(INVITE_AS, role.getId());
        return this;
    }

    /**
     * Sets the number of minutes before the invitation will expire.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/send-invites#parameter-invite_expires_in_minutes">https://zulip.com/api/send-invites#parameter-invite_expires_in_minutes</a>
     *
     * @param  minutes The number of minutes before the invitation will expire
     * @return         This {@link SendInvitationsApiRequest} instance
     */
    public SendInvitationsApiRequest inviteExpiresInMinutes(int minutes) {
        putParam(INVITE_EXPIRES_IN_MINUTES, minutes);
        return this;
    }

    /**
     * Sets whether the referrer would like to receive a direct message from notification bot when a user account is created.
     *
     * @see                         <a href=
     *                              "https://zulip.com/api/send-invites#parameter-notify_referrer_on_join">https://zulip.com/api/send-invites#parameter-notify_referrer_on_join</a>
     *
     * @param  notifyReferrerOnJoin When {@code true} the referrer will receive a direct message from notification bot when a
     *                              user account is created. When {@code false} no notification is sent
     * @return                      This {@link SendInvitationsApiRequest} instance
     */
    public SendInvitationsApiRequest withNotifyReferrerOnJoin(boolean notifyReferrerOnJoin) {
        putParam(NOTIFIY_REFERRER_ON_JOIN, notifyReferrerOnJoin);
        return this;
    }

    /**
     * Sets a custom message to be sent by the Welcome Bot to new users that join the organization via this invitation.
     *
     * @see                             <a href=
     *                                  "https://zulip.com/api/send-invites#parameter-welcome_message_custom_text">https://zulip.com/api/send-invites#parameter-welcome_message_custom_text</a>
     *
     * @param  welcomeMessageCustomText The welcome message content
     * @return                          This {@link SendInvitationsApiRequest} instance
     */
    public SendInvitationsApiRequest withWelcomeMessageCustomText(String welcomeMessageCustomText) {
        if (welcomeMessageCustomText != null && welcomeMessageCustomText.length() > 8000) {
            throw new IllegalArgumentException("Welcome message custom text cannot be longer than 8000 characters");
        }
        putParam(WELCOME_MESSAGE_CUSTOM_TEXT, welcomeMessageCustomText);
        return this;
    }

    /**
     * Executes the Zulip API request for sending user invitations.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(INVITATIONS_API_PATH, getParams(), ZulipApiResponse.class);
    }
}

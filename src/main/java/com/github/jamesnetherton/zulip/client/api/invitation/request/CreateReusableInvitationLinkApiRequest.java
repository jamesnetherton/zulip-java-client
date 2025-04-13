package com.github.jamesnetherton.zulip.client.api.invitation.request;

import static com.github.jamesnetherton.zulip.client.api.invitation.request.InvitationRequestConstants.MULTIUSE_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.invitation.response.CreateReusableInvitationLinkApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserRole;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a reusable invitation link.
 *
 * @see <a href="https://zulip.com/api/create-invite-link">https://zulip.com/api/create-invite-link</a>
 */
public class CreateReusableInvitationLinkApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {
    public static final String GROUP_IDS = "group_ids";
    public static final String INCLUDE_REALM_DEFAULT_SUBSCRIPTIONS = "include_realm_default_subscriptions";
    public static final String INVITE_AS = "invite_as";
    public static final String INVITE_EXPIRES_IN_MINUTES = "invite_expires_in_minutes";
    public static final String STREAM_IDS = "stream_ids";

    /**
     * Constructs a {@link CreateReusableInvitationLinkApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public CreateReusableInvitationLinkApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Sets the ids of groups that the user should be added to upon accepting the invitation.
     *
     * @see             <a href=
     *                  "https://zulip.com/api/create-invite-link#parameter-group_ids">https://zulip.com/api/create-invite-link#parameter-group_ids</a>
     *
     * @param  groupIds The ids of the invited user should be added to
     * @return          This {@link CreateReusableInvitationLinkApiRequest} instance
     */
    public CreateReusableInvitationLinkApiRequest withGroupIds(long... groupIds) {
        putParamAsJsonString(GROUP_IDS, groupIds);
        return this;
    }

    /**
     * Sets whether the newly created user should be subscribed to the default channels for the organization.
     *
     * @see                                     <a href=
     *                                          "https://zulip.com/api/create-invite-link#parameter-include_realm_default_subscriptions">https://zulip.com/api/create-invite-link#parameter-include_realm_default_subscriptions</a>
     *
     * @param  includeRealmDefaultSubscriptions When {@code true}, the newly created user will be subscribed to the default
     *                                          channels for the organization. When {@code false} the user is not subscribed to
     *                                          any default channels.
     * @return                                  This {@link CreateReusableInvitationLinkApiRequest} instance
     */
    public CreateReusableInvitationLinkApiRequest withIncludeRealmDefaultSubscriptions(
            boolean includeRealmDefaultSubscriptions) {
        putParam(INCLUDE_REALM_DEFAULT_SUBSCRIPTIONS, includeRealmDefaultSubscriptions);
        return this;
    }

    /**
     * Sets the organization level role of the user that is created when the invitation is accepted.
     *
     * @see         <a href=
     *              "https://zulip.com/api/create-invite-link#parameter-invite_as">https://zulip.com/api/create-invite-link#parameter-invite_as</a>
     *
     * @param  role The {@link UserRole} that should apply to the new user
     * @return      This {@link CreateReusableInvitationLinkApiRequest} instance
     */
    public CreateReusableInvitationLinkApiRequest withInviteAs(UserRole role) {
        putParam(INVITE_AS, role.getId());
        return this;
    }

    /**
     * Sets the number of minutes before the invitation will expire.
     *
     * @see            <a href=
     *                 "https://zulip.com/api/create-invite-link#parameter-invite_expires_in_minutes">https://zulip.com/api/create-invite-link#parameter-invite_expires_in_minutes</a>
     *
     * @param  minutes The number of minutes before the invitation will expire
     * @return         This {@link CreateReusableInvitationLinkApiRequest} instance
     */
    public CreateReusableInvitationLinkApiRequest inviteExpiresInMinutes(int minutes) {
        putParam(INVITE_EXPIRES_IN_MINUTES, minutes);
        return this;
    }

    /**
     * Sets the list of channel ids that the newly created user will be automatically subscribed to.
     *
     * @see              <a href=
     *                   "https://zulip.com/api/create-invite-link#parameter-stream_ids">https://zulip.com/api/create-invite-link#parameter-stream_ids</a>
     *
     * @param  streamIds The ids of channels that the newly created user will be automatically subscribed to
     * @return           This {@link CreateReusableInvitationLinkApiRequest} instance
     */
    public CreateReusableInvitationLinkApiRequest streamIds(long... streamIds) {
        putParamAsJsonString(STREAM_IDS, streamIds);
        return this;
    }

    /**
     * Executes the Zulip API request for creating a reusable invitation link.
     *
     * @return                      The generated invitation link URL
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        return client().post(MULTIUSE_API_PATH, getParams(), CreateReusableInvitationLinkApiResponse.class).getInviteLink();
    }
}

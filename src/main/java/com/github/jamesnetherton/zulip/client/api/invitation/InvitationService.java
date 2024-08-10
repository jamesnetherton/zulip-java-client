package com.github.jamesnetherton.zulip.client.api.invitation;

import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.invitation.request.CreateReusableInvitationLinkApiRequest;
import com.github.jamesnetherton.zulip.client.api.invitation.request.GetAllInvitationsApiRequest;
import com.github.jamesnetherton.zulip.client.api.invitation.request.ResendEmailInvitationApiRequest;
import com.github.jamesnetherton.zulip.client.api.invitation.request.RevokeEmailInvitationApiRequest;
import com.github.jamesnetherton.zulip.client.api.invitation.request.RevokeReusableInvitationApiRequest;
import com.github.jamesnetherton.zulip.client.api.invitation.request.SendInvitationsApiRequest;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip invitation APIs.
 */
public class InvitationService implements ZulipService {

    private final ZulipHttpClient client;

    /**
     * Constructs a {@link InvitationService}.
     *
     * @param client The Zulip HTTP client
     */
    public InvitationService(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Creates a new invitation link.
     *
     * @see    <a href="https://zulip.com/api/create-invite-link">https://zulip.com/api/create-invite-link</a>
     *
     * @return The {@link CreateReusableInvitationLinkApiRequest} builder object
     */
    public CreateReusableInvitationLinkApiRequest createReusableInvitationLink() {
        return new CreateReusableInvitationLinkApiRequest(client);
    }

    /**
     * Fetches all unexpired invitations.
     *
     * @see    <a href="https://zulip.com/api/get-invites">https://zulip.com/api/get-invites</a>
     *
     * @return The {@link GetAllInvitationsApiRequest} builder object
     */
    public GetAllInvitationsApiRequest getAllInvitations() {
        return new GetAllInvitationsApiRequest(client);
    }

    /**
     * Resends an email invitation.
     *
     * @see                 <a href="https://zulip.com/api/resend-email-invite">https://zulip.com/api/resend-email-invite</a>
     *
     * @param  invitationId The id of the invitation to resend
     * @return              The {@link ResendEmailInvitationApiRequest} builder object
     */
    public ResendEmailInvitationApiRequest resendEmailInvitation(long invitationId) {
        return new ResendEmailInvitationApiRequest(client, invitationId);
    }

    /**
     * Revokes an email invitation.
     *
     * @see                 <a href="https://zulip.com/api/revoke-email-invite">https://zulip.com/api/revoke-email-invite</a>
     *
     * @param  invitationId The id of the invitation to revoke
     * @return              The {@link RevokeEmailInvitationApiRequest} builder object
     */
    public RevokeEmailInvitationApiRequest revokeEmailInvitation(long invitationId) {
        return new RevokeEmailInvitationApiRequest(client, invitationId);
    }

    /**
     * Revokes a reusable invitation.
     *
     * @see                 <a href="https://zulip.com/api/revoke-invite-link">https://zulip.com/api/revoke-invite-link</a>
     *
     * @param  invitationId The id of the invitation to revoke
     * @return              The {@link RevokeReusableInvitationApiRequest} builder object
     */
    public RevokeReusableInvitationApiRequest revokeReusableInvitation(long invitationId) {
        return new RevokeReusableInvitationApiRequest(client, invitationId);
    }

    /**
     * Send invitations to specified email addresses.
     *
     * @see                  <a href="https://zulip.com/api/send-invites">https://zulip.com/api/send-invites</a>
     *
     * @param  inviteeEmails The list of email addresses to invite
     * @param  streamIds     The list of channel ids that the newly created user will be automatically subscribed to
     * @return               The {@link SendInvitationsApiRequest} builder object
     */
    public SendInvitationsApiRequest sendInvitations(List<String> inviteeEmails, List<Long> streamIds) {
        return new SendInvitationsApiRequest(client, inviteeEmails, streamIds);
    }
}

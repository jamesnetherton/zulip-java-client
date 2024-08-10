package com.github.jamesnetherton.zulip.client.api.invitation.request;

import static com.github.jamesnetherton.zulip.client.api.invitation.request.InvitationRequestConstants.RESEND;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for resending an email invitation.
 *
 * @see <a href="https://zulip.com/api/resend-email-invite">https://zulip.com/api/resend-email-invite</a>
 */
public class ResendEmailInvitationApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    private final long invitationId;

    /**
     * Constructs a {@link ResendEmailInvitationApiRequest}.
     *
     * @param client       The Zulip HTTP client
     * @param invitationId The id of the invitation to resend
     */
    public ResendEmailInvitationApiRequest(ZulipHttpClient client, long invitationId) {
        super(client);
        this.invitationId = invitationId;
    }

    /**
     * Executes the Zulip API request for resending an email invitation.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(RESEND, invitationId);
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}

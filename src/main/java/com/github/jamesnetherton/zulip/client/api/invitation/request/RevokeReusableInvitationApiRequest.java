package com.github.jamesnetherton.zulip.client.api.invitation.request;

import static com.github.jamesnetherton.zulip.client.api.invitation.request.InvitationRequestConstants.MULTIUSE_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for revoking a reusable invitation.
 *
 * @see <a href="https://zulip.com/api/revoke-invite-link">https://zulip.com/api/revoke-invite-link</a>
 */
public class RevokeReusableInvitationApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    private final long invitationId;

    /**
     * Constructs a {@link RevokeReusableInvitationApiRequest}.
     *
     * @param client       The Zulip HTTP client
     * @param invitationId The id of the invitation to revoke
     */
    public RevokeReusableInvitationApiRequest(ZulipHttpClient client, long invitationId) {
        super(client);
        this.invitationId = invitationId;
    }

    /**
     * Executes the Zulip API request for revoking a reusable invitation.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(MULTIUSE_WITH_ID, invitationId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}

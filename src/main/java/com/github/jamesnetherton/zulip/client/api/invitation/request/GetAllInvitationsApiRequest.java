package com.github.jamesnetherton.zulip.client.api.invitation.request;

import static com.github.jamesnetherton.zulip.client.api.invitation.request.InvitationRequestConstants.INVITATIONS_API_PATH;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.invitation.Invitation;
import com.github.jamesnetherton.zulip.client.api.invitation.response.GetAllInvitationsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for fetching invitations.
 *
 * @see <a href="https://zulip.com/api/get-invites">https://zulip.com/api/get-invites</a>
 */
public class GetAllInvitationsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<Invitation>> {
    /**
     * Constructs a {@link GetAllInvitationsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetAllInvitationsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for fetching invitations.
     *
     * @return                      List of {@link Invitation} containing each unexpired invitation
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<Invitation> execute() throws ZulipClientException {
        return client().get(INVITATIONS_API_PATH, getParams(), GetAllInvitationsApiResponse.class).getInvites();
    }
}

package com.github.jamesnetherton.zulip.client.api.invitation.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.invitation.Invitation;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for fetching invitations.
 *
 * @see <a href="https://zulip.com/api/get-invites#response">https://zulip.com/api/get-invites#response</a>
 */
public class GetAllInvitationsApiResponse extends ZulipApiResponse {
    @JsonProperty
    List<Invitation> invites = new ArrayList<>();

    public List<Invitation> getInvites() {
        return invites;
    }
}

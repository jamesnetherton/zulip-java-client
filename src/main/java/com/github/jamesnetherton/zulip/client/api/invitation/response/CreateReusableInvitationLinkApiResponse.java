package com.github.jamesnetherton.zulip.client.api.invitation.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for creating a reusable invitation link.
 *
 * @see <a href="https://zulip.com/api/create-invite-link#response">https://zulip.com/api/create-invite-link#response</a>
 */
public class CreateReusableInvitationLinkApiResponse extends ZulipApiResponse {
    @JsonProperty
    private String inviteLink;

    public String getInviteLink() {
        return inviteLink;
    }
}

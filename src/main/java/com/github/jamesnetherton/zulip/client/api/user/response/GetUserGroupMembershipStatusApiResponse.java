package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for getting user group membership status for a user.
 *
 * @see <a href=
 *      "https://zulip.com/api/get-is-user-group-member#response">https://zulip.com/api/get-is-user-group-member#response</a>
 */
public class GetUserGroupMembershipStatusApiResponse extends ZulipApiResponse {

    @JsonProperty
    private boolean isUserGroupMember;

    public boolean isUserGroupMember() {
        return isUserGroupMember;
    }
}

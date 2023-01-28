package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.List;

/**
 * Zulip API response class for getting user group members.
 *
 * @see <a href=
 *      "https://zulip.com/api/get-user-group-members#response">https://zulip.com/api/get-user-group-members#response</a>
 */
public class GetUserGroupMembersApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Long> members;

    public List<Long> getMembers() {
        return members;
    }
}

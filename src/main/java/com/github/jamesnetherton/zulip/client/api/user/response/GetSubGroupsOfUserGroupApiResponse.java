package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.List;

/**
 * Zulip API response class for getting sub groups of a user group.
 *
 * @see <a href="https://zulip.com/api/get-user-group-subgroups">https://zulip.com/api/get-user-group-subgroups</a>
 */
public class GetSubGroupsOfUserGroupApiResponse extends ZulipApiResponse {

    @JsonProperty("subgroups")
    private List<Long> subGroups;

    public List<Long> getSubGroups() {
        return subGroups;
    }
}

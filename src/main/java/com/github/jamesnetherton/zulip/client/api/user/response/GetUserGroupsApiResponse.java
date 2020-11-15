package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.user.UserGroup;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all user groups.
 *
 * @see <a href="https://zulip.com/api/get-user-groups#response">https://zulip.com/api/get-user-groups#response</a>
 */
public class GetUserGroupsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<UserGroup> userGroups = new ArrayList<>();

    public List<UserGroup> getUserGroups() {
        return userGroups;
    }
}

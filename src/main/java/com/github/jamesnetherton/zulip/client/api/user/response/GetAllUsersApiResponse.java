package com.github.jamesnetherton.zulip.client.api.user.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all users.
 *
 * @see <a href="https://zulip.com/api/get-users#response">https://zulip.com/api/get-users#response</a>
 */
public class GetAllUsersApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<UserApiResponse> members = new ArrayList<>();

    public List<UserApiResponse> getMembers() {
        return members;
    }
}

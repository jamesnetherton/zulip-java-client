package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.UserGroup;
import com.github.jamesnetherton.zulip.client.api.user.response.GetUserGroupsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all user groups.
 *
 * @see <a href="https://zulip.com/api/get-user-groups">https://zulip.com/api/get-user-groups</a>
 */
public class GetUserGroupsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<UserGroup>> {

    /**
     * Constructs a {@link GetUserGroupsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetUserGroupsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all user groups.
     *
     * @return                      List of {@link UserGroup} objects
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<UserGroup> execute() throws ZulipClientException {
        GetUserGroupsApiResponse response = client().get(USER_GROUPS, getParams(), GetUserGroupsApiResponse.class);
        return response.getUserGroups();
    }
}

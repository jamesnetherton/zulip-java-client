package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a user group.
 *
 * @see <a href="https://zulip.com/api/remove-user-group">https://zulip.com/api/remove-user-group</a>
 */
public class DeleteUserGroupApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long groupId;

    /**
     * Constructs a {@link DeleteUserGroupApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param groupId The id of the group to delete
     */
    public DeleteUserGroupApiRequest(ZulipHttpClient client, long groupId) {
        super(client);
        this.groupId = groupId;
    }

    /**
     * Executes the Zulip API request for deleting a user group.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(USER_GROUPS_WITH_ID, groupId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}

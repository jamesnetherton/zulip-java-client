package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USER_GROUPS_DEACTIVATE;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deactivating a user group.
 *
 * @see <a href="https://zulip.com/api/deactivate-user-group">https://zulip.com/api/deactivate-user-group</a>
 */
public class DeactivateUserGroupApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final long userGroupId;

    /**
     * Constructs a {@link DeactivateUserGroupApiRequest}.
     *
     * @param client      The Zulip HTTP client
     * @param userGroupId The id of the user group to deactivate
     */
    public DeactivateUserGroupApiRequest(ZulipHttpClient client, long userGroupId) {
        super(client);
        this.userGroupId = userGroupId;
    }

    /**
     * Executes the Zulip API request for deactivating a user group.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(USER_GROUPS_DEACTIVATE, userGroupId);
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}

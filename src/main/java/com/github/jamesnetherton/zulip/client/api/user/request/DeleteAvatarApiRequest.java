package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_AVATAR;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.AvatarApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting the user avatar and reverting to the default avatar.
 *
 * @see <a href="https://zulip.com/api/delete-avatar">https://zulip.com/api/delete-avatar</a>
 */
public class DeleteAvatarApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    /**
     * Constructs a {@link DeleteAvatarApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public DeleteAvatarApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for deleting the user avatar.
     *
     * @return                      The URL of the default avatar
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        return client().delete(USERS_AVATAR, getParams(), AvatarApiResponse.class).getAvatarUrl();
    }
}

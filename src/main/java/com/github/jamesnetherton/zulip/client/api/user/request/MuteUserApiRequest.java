package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_MUTED_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for muting a user.
 *
 * @see <a href="https://zulip.com/api/mute-user">https://zulip.com/api/mute-user</a>
 */
public class MuteUserApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    private final String path;

    /**
     * Constructs a {@link MuteUserApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public MuteUserApiRequest(ZulipHttpClient client, long userId) {
        super(client);
        this.path = String.format(USERS_MUTED_WITH_ID, userId);
    }

    /**
     * Executes the Zulip API request for muting a user.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().post(path, getParams(), ZulipApiResponse.class);
    }
}

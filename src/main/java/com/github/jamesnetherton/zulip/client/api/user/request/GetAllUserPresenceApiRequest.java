package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_REALM_PRESENCE;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceDetail;
import com.github.jamesnetherton.zulip.client.api.user.response.GetAllUserPresenceApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Map;

/**
 * Zulip API request builder for getting all user presence.
 *
 * @see <a href="https://zulip.com/api/get-presence">https://zulip.com/api/get-presence</a>
 */
public class GetAllUserPresenceApiRequest extends ZulipApiRequest
        implements ExecutableApiRequest<Map<String, Map<String, UserPresenceDetail>>> {
    /**
     * Constructs a {@link GetAllUserPresenceApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetAllUserPresenceApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all user presence.
     *
     * @return                      Map of user presence details keyed bu user id or email address
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Map<String, Map<String, UserPresenceDetail>> execute() throws ZulipClientException {
        return client().get(USERS_REALM_PRESENCE, getParams(), GetAllUserPresenceApiResponse.class).getPresences();
    }
}

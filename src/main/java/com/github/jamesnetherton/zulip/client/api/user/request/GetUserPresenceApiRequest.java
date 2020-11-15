package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_PRESENCE;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.UserPresenceDetail;
import com.github.jamesnetherton.zulip.client.api.user.response.GetUserPresenceApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.Map;

/**
 * Zulip API request builder for getting user presence information.
 *
 * @see <a href="https://zulip.com/api/get-user-presence">https://zulip.com/api/get-user-presence</a>
 */
public class GetUserPresenceApiRequest extends ZulipApiRequest
        implements ExecutableApiRequest<Map<String, UserPresenceDetail>> {

    private final String email;

    /**
     * Constructs a {@link GetUserPresenceApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param email  The email address of the user to get presence details for
     */
    public GetUserPresenceApiRequest(ZulipHttpClient client, String email) {
        super(client);
        this.email = email;
    }

    /**
     * Executes the Zulip API request for getting user presence information.
     *
     * @return                      Map of user presence details keyed by the source of the client name and containing a
     *                              {@link UserPresenceDetail} value
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Map<String, UserPresenceDetail> execute() throws ZulipClientException {
        String path = String.format(USERS_PRESENCE, email);
        GetUserPresenceApiResponse response = client().get(path, getParams(), GetUserPresenceApiResponse.class);
        return response.getPresence();
    }
}

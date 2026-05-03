package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ME_PROFILE_DATA;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;
import java.util.Map;

/**
 * Zulip API request builder for updating the current user's custom profile field data.
 *
 * @see <a href="https://zulip.com/api/update-profile-data">https://zulip.com/api/update-profile-data</a>
 */
public class UpdateOwnProfileDataApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String DATA = "data";

    /**
     * Constructs an {@link UpdateOwnProfileDataApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param data   List of maps each containing {@code id} (integer) and {@code value} (string or null) entries
     */
    public UpdateOwnProfileDataApiRequest(ZulipHttpClient client, List<Map<String, Object>> data) {
        super(client);
        putParamAsJsonString(DATA, data);
    }

    /**
     * Executes the Zulip API request for updating the current user's profile data.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().patch(USERS_WITH_ME_PROFILE_DATA, getParams(), ZulipApiResponse.class);
    }
}

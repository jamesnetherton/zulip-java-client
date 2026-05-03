package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ME_PROFILE_DATA;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for removing the current user's custom profile field data.
 *
 * @see <a href="https://zulip.com/api/remove-profile-data">https://zulip.com/api/remove-profile-data</a>
 */
public class DeleteOwnProfileDataApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {

    public static final String DATA = "data";

    /**
     * Constructs a {@link DeleteOwnProfileDataApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param fieldIds List of custom profile field IDs to remove data for
     */
    public DeleteOwnProfileDataApiRequest(ZulipHttpClient client, List<Integer> fieldIds) {
        super(client);
        putParamAsJsonString(DATA, fieldIds);
    }

    /**
     * Executes the Zulip API request for removing the current user's profile data.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        client().delete(USERS_WITH_ME_PROFILE_DATA, getParams(), ZulipApiResponse.class);
    }
}

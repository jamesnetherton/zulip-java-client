package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ME_API_KEY_REGENERATE;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.RegenerateApiKeyApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for regenerating the current user's API key.
 *
 * @see <a href="https://zulip.com/api/regenerate-api-key">https://zulip.com/api/regenerate-api-key</a>
 */
public class RegenerateApiKeyApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    /**
     * Constructs a {@link RegenerateApiKeyApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public RegenerateApiKeyApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for regenerating the current user's API key.
     *
     * @return                      The new API key
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        return client().post(USERS_WITH_ME_API_KEY_REGENERATE, getParams(), RegenerateApiKeyApiResponse.class).getApiKey();
    }
}

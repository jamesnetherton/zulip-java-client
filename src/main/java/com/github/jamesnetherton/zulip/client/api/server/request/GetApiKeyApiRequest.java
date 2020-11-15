package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.DEV_FETCH_API_KEY;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.GetApiKeyApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting a user API development key.
 *
 * This endpoint is not available on production servers. It is for development use only.
 *
 * @see <a href="https://zulip.com/api/dev-fetch-api-key">https://zulip.com/api/dev-fetch-api-key</a>
 */
public class GetApiKeyApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    public static final String USERNAME = "username";

    /**
     * Constructs a {@link GetApiKeyApiRequest}.
     *
     * @param client   The Zulip HTTP client
     * @param username The username to fetch the development API key for
     */
    public GetApiKeyApiRequest(ZulipHttpClient client, String username) {
        super(client);
        putParam(USERNAME, username);
    }

    /**
     * Executes the Zulip API request for getting a user API development key.
     *
     * @return                      The users API development key
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        GetApiKeyApiResponse response = client().post(DEV_FETCH_API_KEY, getParams(), GetApiKeyApiResponse.class);
        return response.getApiKey();
    }
}

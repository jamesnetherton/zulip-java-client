package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.DEV_FETCH_API_KEY;
import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.FETCH_API_KEY;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.GetApiKeyApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for getting a user API key.
 *
 * @see <a href="https://zulip.com/api/fetch-api-key">https://zulip.com/api/fetch-api-key</a>
 * @see <a href="https://zulip.com/api/dev-fetch-api-key">https://zulip.com/api/dev-fetch-api-key</a>
 */
public class GetApiKeyApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String> {

    public static final String PASSWORD = "password";
    public static final String USERNAME = "username";

    private final String path;

    /**
     * Constructs a {@link GetApiKeyApiRequest}. To obtain an API key for development servers
     *
     * @param client   The Zulip HTTP client
     * @param username The username to fetch the development API key for
     */
    public GetApiKeyApiRequest(ZulipHttpClient client, String username) {
        super(client);
        putParam(USERNAME, username);
        this.path = DEV_FETCH_API_KEY;
    }

    /**
     * Constructs a {@link GetApiKeyApiRequest}. To obtain an API key for production servers
     *
     * @param client   The Zulip HTTP client
     * @param username The username to fetch the development API key for
     * @param password The password to fetch the development API key for
     */
    public GetApiKeyApiRequest(ZulipHttpClient client, String username, String password) {
        super(client);
        putParam(USERNAME, username);
        putParam(PASSWORD, password);
        this.path = FETCH_API_KEY;
    }

    /**
     * Executes the Zulip API request for getting a user API development key.
     *
     * @return                      The users API development key
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String execute() throws ZulipClientException {
        GetApiKeyApiResponse response = client().post(this.path, getParams(), GetApiKeyApiResponse.class);
        return response.getApiKey();
    }
}

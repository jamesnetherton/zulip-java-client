package com.github.jamesnetherton.zulip.client.api.server.request;

import static com.github.jamesnetherton.zulip.client.api.server.request.ServerRequestConstants.JWT_FETCH_API_KEY;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.server.response.JwtFetchApiKeyResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for fetching an API key using a JWT token.
 *
 * @see <a href=
 *      "https://zulip.com/api/jwt-fetch-api-key#usage-examples">https://zulip.com/api/jwt-fetch-api-key#usage-examples</a>
 */
public class JwtFetchApiKeyApiRequest extends ZulipApiRequest implements ExecutableApiRequest<JwtFetchApiKeyResponse> {

    public static final String TOKEN = "token";
    public static final String INCLUDE_PROFILE = "include_profile";

    /**
     * Constructs a {@link JwtFetchApiKeyApiRequest}.
     *
     * @param client The Zulip HTTP client
     * @param token  The JWT token
     */
    public JwtFetchApiKeyApiRequest(ZulipHttpClient client, String token) {
        super(client);
        putParam(TOKEN, token);
    }

    /**
     * Sets whether to include the user profile data in the response.
     *
     * @param  includeProfile {@code true} to include the user profile data in the response.
     *                        {@code false} to not include the user profile data in the response
     * @return                This {@link JwtFetchApiKeyApiRequest} instance
     */
    public JwtFetchApiKeyApiRequest withIncludeProfile(boolean includeProfile) {
        putParam(INCLUDE_PROFILE, includeProfile);
        return this;
    }

    /**
     * Executes the Zulip API request for fetching an API key using a JWT token.
     *
     * @return                      {@link JwtFetchApiKeyResponse} containing the API key, email and optionally user data
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public JwtFetchApiKeyResponse execute() throws ZulipClientException {
        return client().post(JWT_FETCH_API_KEY, getParams(), JwtFetchApiKeyResponse.class);
    }
}

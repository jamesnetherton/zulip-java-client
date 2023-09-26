package com.github.jamesnetherton.zulip.client.api.user.request;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.GetAllAlertWordsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ME;


/**
 * Zulip API request builder for Get all the user's configured alert words.
 *
 * @see <a href="https://zulip.com/api/v1/users/me/alert_words">https://zulip.com/api/v1/users/me/alert_wordsr</a>
 */
public class GetAllAlertWordsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String []> {

    public static final String ALERT_WORDS = "alert_words";

    /**
     * Constructs a {@link GetAllAlertWordsApiRequest}.
     *
     * @param client     The Zulip HTTP client
     */
    public GetAllAlertWordsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for creating a new user.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String[] execute() throws ZulipClientException {
        return client().get(USERS_WITH_ME, getParams(), GetAllAlertWordsApiResponse.class).getAlertWords();
    }
}

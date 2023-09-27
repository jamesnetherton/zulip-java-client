package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_WITH_ME;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.GetAllAlertWordsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for set alert words.
 *
 * @see <a href="https://zulip.com/api/v1/users/me/alert_words">https://zulip.com/api/v1/users/me/alert_wordsr</a>
 */
public class AddAlertWordsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<String []> {

    public static final String ALERT_WORDS = "alert_words";

    /**
     * Constructs a {@link AddAlertWordsApiRequest}.
     *
     * @param client     The Zulip HTTP client
     * @param alertWords Add words (or phrases) to the user's set of configured alert words.
     */
    public AddAlertWordsApiRequest(ZulipHttpClient client, String[] alertWords) {
        super(client);
        putParamAsJsonString(ALERT_WORDS, alertWords);
    }

    /**
     * Executes the Zulip API request for set alert words.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public String [] execute() throws ZulipClientException {
        return client().post(USERS_WITH_ME, getParams(), GetAllAlertWordsApiResponse.class).getAlertWords();
    }
}

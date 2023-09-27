package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_ALERT_WORDS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.AlertWordsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for removing user alert words.
 *
 * @see <a href="https://zulip.com/api/v1/users/me/alert_words">https://zulip.com/api/v1/users/me/alert_wordsr</a>
 */
public class RemoveAlertWordsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<String>> {

    public static final String ALERT_WORDS = "alert_words";

    /**
     * Constructs a {@link RemoveAlertWordsApiRequest}.
     *
     * @param client     The Zulip HTTP client
     * @param alertWords An array of strings to be removed from the user's set of configured alert words
     */
    public RemoveAlertWordsApiRequest(ZulipHttpClient client, String... alertWords) {
        super(client);
        putParamAsJsonString(ALERT_WORDS, alertWords);
    }

    /**
     * Executes the Zulip API request for removing user alert words.
     *
     * @return                      List of user alert word strings
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<String> execute() throws ZulipClientException {
        return client().delete(USERS_ALERT_WORDS, getParams(), AlertWordsApiResponse.class).getAlertWords();
    }
}

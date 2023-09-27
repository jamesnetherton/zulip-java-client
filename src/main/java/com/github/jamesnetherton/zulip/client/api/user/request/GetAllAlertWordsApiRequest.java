package com.github.jamesnetherton.zulip.client.api.user.request;

import static com.github.jamesnetherton.zulip.client.api.user.request.UserRequestConstants.USERS_ALERT_WORDS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.user.response.AlertWordsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all user alert words.
 *
 * @see <a href="https://zulip.com/api/get-alert-words">https://zulip.com/api/get-alert-words</a>
 */
public class GetAllAlertWordsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<String>> {

    /**
     * Constructs a {@link GetAllAlertWordsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetAllAlertWordsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all user alert words.
     *
     * @return                      List of user alert word strings
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<String> execute() throws ZulipClientException {
        return client().get(USERS_ALERT_WORDS, getParams(), AlertWordsApiResponse.class).getAlertWords();
    }
}

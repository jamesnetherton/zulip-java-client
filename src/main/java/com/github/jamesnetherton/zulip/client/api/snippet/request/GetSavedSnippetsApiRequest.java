package com.github.jamesnetherton.zulip.client.api.snippet.request;

import static com.github.jamesnetherton.zulip.client.api.snippet.request.SnippetRequestConstants.SAVED_SNIPPETS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.snippet.SavedSnippet;
import com.github.jamesnetherton.zulip.client.api.snippet.response.GetSavedSnippetsApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;
import java.util.List;

/**
 * Zulip API request builder for getting all saved snippets.
 *
 * @see <a href="https://zulip.com/api/get-saved-snippets">https://zulip.com/api/get-saved-snippets</a>
 */
public class GetSavedSnippetsApiRequest extends ZulipApiRequest implements ExecutableApiRequest<List<SavedSnippet>> {

    /**
     * Constructs a {@link GetSavedSnippetsApiRequest}.
     *
     * @param client The Zulip HTTP client
     */
    public GetSavedSnippetsApiRequest(ZulipHttpClient client) {
        super(client);
    }

    /**
     * Executes the Zulip API request for getting all saved snippets.
     *
     * @return
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public List<SavedSnippet> execute() throws ZulipClientException {
        return client().get(SAVED_SNIPPETS, getParams(), GetSavedSnippetsApiResponse.class).getSavedSnippets();
    }
}

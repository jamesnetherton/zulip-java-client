package com.github.jamesnetherton.zulip.client.api.snippet.request;

import static com.github.jamesnetherton.zulip.client.api.snippet.request.SnippetRequestConstants.SAVED_SNIPPETS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for deleting a saved snippet.
 *
 * @see <a href="https://zulip.com/api/delete-saved-snippet">https://zulip.com/api/delete-saved-snippet</a>
 */
public class DeleteSavedSnippetApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    private final long snippetId;

    /**
     * Constructs a {@link DeleteSavedSnippetApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param snippetId The ID of the saved snippet to delete
     */
    public DeleteSavedSnippetApiRequest(ZulipHttpClient client, int snippetId) {
        super(client);
        this.snippetId = snippetId;
    }

    /**
     * Executes the Zulip API request for deleting a saved snippet.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(SAVED_SNIPPETS_WITH_ID, snippetId);
        client().delete(path, getParams(), ZulipApiResponse.class);
    }
}

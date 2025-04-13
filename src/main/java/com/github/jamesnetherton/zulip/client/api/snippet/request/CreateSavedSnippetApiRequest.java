package com.github.jamesnetherton.zulip.client.api.snippet.request;

import static com.github.jamesnetherton.zulip.client.api.snippet.request.SnippetRequestConstants.SAVED_SNIPPETS;

import com.github.jamesnetherton.zulip.client.api.core.ExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.snippet.response.CreateSavedSnippetApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for creating a saved snippet.
 *
 * @see <a href="https://zulip.com/api/create-saved-snippet">https://zulip.com/api/create-saved-snippet</a>
 */
public class CreateSavedSnippetApiRequest extends ZulipApiRequest implements ExecutableApiRequest<Integer> {
    public static final String CONTENT = "content";
    public static final String TITLE = "title";

    /**
     * Constructs a {@link CreateSavedSnippetApiRequest}.
     *
     * @param client  The Zulip HTTP client
     * @param title   The title of the saved snippet
     * @param content The content of the saved snippet in text or Markdown format
     */
    public CreateSavedSnippetApiRequest(ZulipHttpClient client, String title, String content) {
        super(client);
        putParam(CONTENT, content);
        putParam(TITLE, title);
    }

    /**
     * Executes the Zulip API request for creating a saved snippet.
     *
     * @return                      The id of the created saved snippet
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public Integer execute() throws ZulipClientException {
        return client().post(SAVED_SNIPPETS, getParams(), CreateSavedSnippetApiResponse.class).getSavedSnippetId();
    }
}

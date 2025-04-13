package com.github.jamesnetherton.zulip.client.api.snippet.request;

import static com.github.jamesnetherton.zulip.client.api.snippet.request.SnippetRequestConstants.SAVED_SNIPPETS_WITH_ID;

import com.github.jamesnetherton.zulip.client.api.core.VoidExecutableApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiRequest;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.exception.ZulipClientException;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip API request builder for editing a saved snippet.
 *
 * @see <a href="https://zulip.com/api/edit-saved-snippet">https://zulip.com/api/edit-saved-snippet</a>
 */
public class EditSavedSnippetApiRequest extends ZulipApiRequest implements VoidExecutableApiRequest {
    public static final String CONTENT = "content";
    public static final String TITLE = "title";

    private final int snippetId;

    /**
     * Constructs a {@link EditSavedSnippetApiRequest}.
     *
     * @param client    The Zulip HTTP client
     * @param snippetId The ID of the saved snippet to edit
     */
    public EditSavedSnippetApiRequest(ZulipHttpClient client, int snippetId) {
        super(client);
        this.snippetId = snippetId;
    }

    /**
     * Sets the optional saved snippet content to edit.
     *
     * @param  content The new saved snippet content
     * @return         This {@link EditSavedSnippetApiRequest} instance
     */
    public EditSavedSnippetApiRequest withContent(String content) {
        putParam(CONTENT, content);
        return this;
    }

    /**
     * Sets the optional saved snippet title to edit.
     *
     * @param  title The new saved snippet title
     * @return       This {@link EditSavedSnippetApiRequest} instance
     */
    public EditSavedSnippetApiRequest withTitle(String title) {
        putParam(TITLE, title);
        return this;
    }

    /**
     * Executes the Zulip API request for editing a saved snippet.
     *
     * @throws ZulipClientException if the request was not successful
     */
    @Override
    public void execute() throws ZulipClientException {
        String path = String.format(SAVED_SNIPPETS_WITH_ID, snippetId);
        client().patch(path, getParams(), ZulipApiResponse.class);
    }
}

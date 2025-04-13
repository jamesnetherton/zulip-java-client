package com.github.jamesnetherton.zulip.client.api.snippet;

import com.github.jamesnetherton.zulip.client.api.core.ZulipService;
import com.github.jamesnetherton.zulip.client.api.snippet.request.CreateSavedSnippetApiRequest;
import com.github.jamesnetherton.zulip.client.api.snippet.request.DeleteSavedSnippetApiRequest;
import com.github.jamesnetherton.zulip.client.api.snippet.request.EditSavedSnippetApiRequest;
import com.github.jamesnetherton.zulip.client.api.snippet.request.GetSavedSnippetsApiRequest;
import com.github.jamesnetherton.zulip.client.http.ZulipHttpClient;

/**
 * Zulip saved snippet APIs.
 */
public class SnippetService implements ZulipService {
    private final ZulipHttpClient client;

    /**
     * Constructs a {@link SnippetService}
     *
     * @param client The Zulip HTTP client
     */
    public SnippetService(ZulipHttpClient client) {
        this.client = client;
    }

    /**
     * Creates a new saved snippet.
     *
     * @see            <a href="https://zulip.com/api/create-saved-snippet">https://zulip.com/api/create-saved-snippet</a>
     *
     * @param  title   The title of the saved snippet
     * @param  content The content of the saved snippet in text or Markdown format.
     * @return         The {@link CreateSavedSnippetApiRequest} builder object
     */
    public CreateSavedSnippetApiRequest createSavedSnippet(String title, String content) {
        return new CreateSavedSnippetApiRequest(client, title, content);
    }

    /**
     * Deletes a saved snippet.
     *
     * @see    <a href="https://zulip.com/api/delete-saved-snippet">https://zulip.com/api/delete-saved-snippet</a>
     *
     * @return The {@link DeleteSavedSnippetApiRequest} builder object
     */
    public DeleteSavedSnippetApiRequest deleteSavedSnippet(int snippetId) {
        return new DeleteSavedSnippetApiRequest(client, snippetId);
    }

    /**
     * Edits a saved snippet.
     *
     * @see    <a href="https://zulip.com/api/edit-saved-snippet">https://zulip.com/api/edit-saved-snippet</a>
     *
     * @return The {@link EditSavedSnippetApiRequest} builder object
     */
    public EditSavedSnippetApiRequest editSavedSnippet(int snippetId) {
        return new EditSavedSnippetApiRequest(client, snippetId);
    }

    /**
     * Gets all saved snippets.
     *
     * @see    <a href="https://zulip.com/api/get-saved-snippets">https://zulip.com/api/get-saved-snippets</a>
     *
     * @return The {@link GetSavedSnippetsApiRequest} builder object
     */
    public GetSavedSnippetsApiRequest getSavedSnippets() {
        return new GetSavedSnippetsApiRequest(client);
    }
}

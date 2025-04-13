package com.github.jamesnetherton.zulip.client.api.snippet.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.snippet.SavedSnippet;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for getting all saved snippets.
 *
 * @see <a href="https://zulip.com/api/get-saved-snippets#response">https://zulip.com/api/get-saved-snippets#response</a>
 */
public class GetSavedSnippetsApiResponse extends ZulipApiResponse {
    @JsonProperty
    private List<SavedSnippet> savedSnippets = new ArrayList<>();

    public List<SavedSnippet> getSavedSnippets() {
        return savedSnippets;
    }
}

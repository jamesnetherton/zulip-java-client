package com.github.jamesnetherton.zulip.client.api.snippet.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;

/**
 * Zulip API response class for creating a saved snippet.
 *
 * @see <a href="https://zulip.com/api/create-saved-snippet#response">https://zulip.com/api/create-saved-snippet#response</a>
 */
public class CreateSavedSnippetApiResponse extends ZulipApiResponse {
    @JsonProperty
    private Integer savedSnippetId;

    public Integer getSavedSnippetId() {
        return savedSnippetId;
    }
}

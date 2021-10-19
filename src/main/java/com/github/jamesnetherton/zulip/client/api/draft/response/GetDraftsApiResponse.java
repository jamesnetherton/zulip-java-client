package com.github.jamesnetherton.zulip.client.api.draft.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import com.github.jamesnetherton.zulip.client.api.draft.Draft;
import java.util.List;

/**
 * Zulip API response class for getting drafts for the current user.
 *
 * @see <a href="https://zulip.com/api/get-drafts#response">https://zulip.com/api/get-drafts#response</a>
 */
public class GetDraftsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Draft> drafts;

    public List<Draft> getDrafts() {
        return drafts;
    }
}

package com.github.jamesnetherton.zulip.client.api.draft.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.github.jamesnetherton.zulip.client.api.core.ZulipApiResponse;
import java.util.ArrayList;
import java.util.List;

/**
 * Zulip API response class for creating drafts.
 *
 * @see <a href="https://zulip.com/api/create-drafts#response">https://zulip.com/api/create-drafts#response</a>
 */
public class CreateDraftsApiResponse extends ZulipApiResponse {

    @JsonProperty
    private List<Long> ids = new ArrayList<>();

    public List<Long> getIds() {
        return ids;
    }
}
